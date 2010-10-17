
use Grid_def;


//|\""""""""""""""""""""|\
//| >    Level class    | >
//|/____________________|/
class Level {

  var is_complete: bool = false;
  
  var x_low, x_high: dimension*real,
      n_cells:       dimension*int,
      n_ghost_cells: dimension*int,
      dx:            dimension*real;


  //==== Cell domains ====
  //--------------------------------------------------------------------
  // Not meant for iteration, but they describe how the Level's indices
  // relate to physical space.
  //--------------------------------------------------------------------
  var ext_cells: domain(dimension, stridable=true);
  var cells:     subdomain(ext_cells);


  //==== Child grid info ====
  var grids:            domain(Grid);
  var sibling_overlaps: [grids] SiblingOverlap;
  var boundary: [grids] MultiDomain(dimension,stridable=true);



  //|\''''''''''''''''''''''''''''|\
  //| >    initialize() method    | >
  //|/............................|/
  //--------------------------------------------------------------------
  // Sets dx and cell domains, based on the mandatory input parameters.
  //--------------------------------------------------------------------
  def initialize() {
    dx = (x_high - x_low) / n_cells;


    //==== Set cell domains ====
    var range_tuple: dimension*range(stridable = true);
    for d in dimensions do
      range_tuple(d) = 1 .. #2*n_cells(d) by 2;
    cells = range_tuple;

    var size: dimension*int;
    for d in dimensions do
      size(d) = 2*n_ghost_cells(d);
    ext_cells = cells.expand(size);

  }
  // /|''''''''''''''''''''''''''''/|
  //< |    initialize() method    < |
  // \|............................\|
  

  //|\''''''''''''''''''''''''''''|\
  //| >    snapToVertex method    | >
  //|/............................|/
  //------------------------------------------------------
  // Provided a real coordinate, returns the index of the
  // nearest vertex.  Useful when defining a grid by
  // its real bounds.
  //------------------------------------------------------
  def snapToVertex(x: dimension*real) {

    var idx: dimension*int;

    for d in dimensions do
      idx(d) = 2 * round((x(d) - x_low(d)) / dx(d)) : int;

    return idx;

  }
  // /|''''''''''''''''''''''''''''/|
  //< |    snapToVertex method    < |
  // \|............................\|



  //|\'''''''''''''''''''''''''|\
  //| >    writeThis method    | >
  //|/.........................|/
  def writeThis(w: Writer) {
    writeln("Level bounds: ", x_low, "  ", x_high);
    writeln("Number of cells: ", n_cells);
    writeln("Number of ghost cells: ", n_ghost_cells);
    writeln("========================================");
    var grid_number: int = 0;
    for grid in grids {
      grid_number += 1;
      writeln("Grid ", grid_number);
      writeln(grid);
      writeln("");
    }
    writeln("========================================");
  }
  // /|'''''''''''''''''''''''''/|
  //< |    writeThis method    < |
  // \|.........................\|

}
// /|""""""""""""""""""""/|
//< |    Level class    < |
// \|____________________\|




//|\""""""""""""""""""""""""""""""|\
//| >    Level.addGrid methods    | >
//|/______________________________|/
//--------------------------------------------------------
// This version is based on indices, and probably best to
// use in practice, as integer arithmetic is cleaner than
// real arithmetic.
//--------------------------------------------------------
def Level.addGrid(
  i_low_grid:  dimension*int,
  i_high_grid: dimension*int)
{

  //==== Safety check ====  
  assert(is_complete == false,
	 "Attempted to add grid to a completed level.");

  //==== Derive grid fields from index bounds and parent (this) info ====
  var x_low_grid, x_high_grid: dimension*real;
  var n_cells_grid:            dimension*int;

  for d in dimensions {
    x_low_grid(d)   = x_low(d) + i_low_grid(d)  * dx(d)/2.0;
    x_high_grid(d)  = x_low(d) + i_high_grid(d) * dx(d)/2.0;
    n_cells_grid(d) = (i_high_grid(d) - i_low_grid(d)) / 2;
  }


  //==== Create and add new grid ====
  var new_grid = new Grid(x_low         = x_low_grid,
                          x_high        = x_high_grid,
                          i_low         = i_low_grid,
                          n_cells       = n_cells_grid,
                          n_ghost_cells = n_ghost_cells);

  grids.add(new_grid);
}


//---------------------------------------------------
// This version takes the full domain of grid cells.
//---------------------------------------------------
def Level.addGrid(
  grid_cells: domain(dimension,stridable=true))
{
  addGrid(grid_cells.low-1, grid_cells.high+1);
}


//----------------------------------------------------------
// This version takes in real bounds, and snaps them to the
// level's discretization.
//----------------------------------------------------------
def Level.addGrid(
  x_low_grid:  dimension*real,
  x_high_grid: dimension*real)
{

  var i_low_grid  = snapToVertex(x_low_grid);
  var i_high_grid = snapToVertex(x_high_grid);

  addGrid(i_low_grid, i_high_grid);

}
// /|""""""""""""""""""""""""""""""/|
//< |    Level.addGrid methods    < |
// \|______________________________\|





//|\""""""""""""""""""""""""""""""|\
//| >    Level.complete method    | >
//|/______________________________|/
//----------------------------------------------------------------
// This method is meant to be called after all grids are added to
// the level.  Neighbor data is set on each grid, and other post-
// processing can be added here as needed.
//----------------------------------------------------------------
def Level.complete() {

  //==== Safety check ====
  assert(is_complete == false,
	 "Attempted to complete a completed level.");

  //==== Set overlap and boundary data ====
  for grid in grids {
    sibling_overlaps(grid) = new SiblingOverlap(this,grid);
    
    boundary(grid) = new MultiDomain(dimension,stridable=true);
    boundary(grid).add(grid.ghost_multidomain);
    for overlap_domain in sibling_overlaps(grid).domains do
      boundary(grid).subtract(overlap_domain);
  }

  //==== Finish ====
  is_complete = true;

}
// /|""""""""""""""""""""""""""""""/|
//< |    Level.complete method    < |
// \|______________________________\|




//|\"""""""""""""""""""""""""""""|\
//| >    SiglingOverlap class    | >
//|/_____________________________|/
//----------------------------------------------------------------------
// Describes the overlap of a Grid with its siblings on a Level.
// Each overlap is the Grid's ghost cells, overlapped with a neighbor's
// interior cells.  However, the intersection will always be a single
// rectangle, and therefore each overlap may be described by a domain.
//----------------------------------------------------------------------
class SiblingOverlap {
  const neighbors: domain(Grid);
  const domains:   [neighbors] domain(dimension,stridable=true);
  
  //|\''''''''''''''''''''|\
  //| >    constructor    | >
  //|/....................|/
  def SiblingOverlap(
    level: Level,
    grid:  Grid)
  {
    for sibling in level.grids {
      if sibling != grid {
        var overlap = grid.ext_cells( sibling.cells );
        if overlap.numIndices>0 {
          neighbors.add(sibling);
          domains(sibling) = overlap;
        }
      }      
    }
  }
  // /|''''''''''''''''''''/|
  //< |    constructor    < |
  // \|....................\|
  
 
  //|\'''''''''''''''''''''''''|\
  //| >    these() iterator    | >
  //|/.........................|/
  def these() {
    for nbr in neighbors do
      yield (nbr, domains(nbr));
  }
  // /|'''''''''''''''''''''''''/|
  //< |    these() iterator    < |
  // \|.........................\|
  
}
// /|"""""""""""""""""""""""""""""/|
//< |    SiblingOverlap class    < |
// \|_____________________________\|





//|\"""""""""""""""""""""""""""""""""""""|\
//| >    Level.ordered_grids iterator    | >
//|/_____________________________________|/
//---------------------------------------------------------------
// While grids don't need to be ordered in terms of computation,
// they should be ordered when writing output, so that the
// output is well-defined.  Otherwise, regressions are much
// more difficult.
//---------------------------------------------------------------
def Level.ordered_grids {    
  var grid_list = grids;
  
  while grid_list.numIndices > 0 {
    var lowest_grid: Grid;
    var i_lowest = ext_cells.high;

    for grid in grid_list {
      for d in dimensions {
        if grid.i_low(d) > i_lowest(d) then
          break;
        else if grid.i_low(d) < i_lowest(d) {
          i_lowest = grid.i_low;
          lowest_grid = grid;
          break;
        }
        
      }
    }
    
    yield lowest_grid;
    grid_list.remove(lowest_grid);
  }
}
// /|"""""""""""""""""""""""""""""""""""""/|
//< |    Level.ordered_grids iterator    < |
// \|_____________________________________\|



//|""""""""""""""""""""""""""""""""""\
//|===> levelFromInputFile routine ===>
//|__________________________________/
//------------------------------------------------------------------
// Creates a Level, provided an input file starting on the line
// where the level's definition begins.
//------------------------------------------------------------------
def readLevel(file_name: string){

  var input_file = new file(file_name, FileAccessMode.read);
  input_file.open();

  var dim_in: int;
  input_file.readln(dim_in);
  assert(dim_in == dimension, 
         "error: dimension of space.txt must equal " + format("%i",dimension));
  input_file.readln(); // empty line

  var x_low, x_high:    dimension*real;
  var n_cells, n_ghost: dimension*int;

  input_file.readln( (...x_low) );
  input_file.readln( (...x_high) );
  input_file.readln( (...n_cells) );
  input_file.readln( (...n_ghost) );

  var level = new Level(x_low         = x_low,
			x_high        = x_high,
			n_cells       = n_cells,
			n_ghost_cells = n_ghost);

  input_file.readln();

  var n_grids: int;
  input_file.readln(n_grids);

  for i_grid in [1..n_grids] {
    input_file.readln();
    input_file.readln( (...x_low) );
    input_file.readln( (...x_high) );
    level.addGrid(x_low, x_high);
  }

  level.complete();

  return level;

}
// /""""""""""""""""""""""""""""""""""|
//<=== levelFromInputFile routine <===|
// \__________________________________|






/* //|"""""""""""""""""""""""""""""\ */
/* //|===> LevelGhostCells class ===> */
/* //|_____________________________/ */
/* class LevelGhostCells { */
/*   const level:             Level; */
/*   var   grid_ghost_cells: [level.grids] GhostCells; */

/*   def LevelGhostCells(level: Level){ */
/*     this.level = level; */
/*   } */

/*   def this(grid: Grid) var { */
/*     return grid_ghost_cells(grid); */
/*   } */
/* } */
/* // /"""""""""""""""""""""""""""""| */
/* //<=== LevelGhostCells class <===| */
/* // \_____________________________| */



// //|""""""""""""""""""""""""""""""""\
// //|===> LevelGhostArraySet class ===>
// //|________________________________/
// class LevelGhostArraySet {
//   const level: Level;
//   var ghost_array_sets: [level.grids] GhostArraySet;
// 
//   def initialize() {
//     for grid in level.grids do
//       ghost_array_sets(grid) = new GhostArraySet(grid);
//   }
// 
//   def this(grid: Grid) {
//     return ghost_array_sets(grid);
//   }
// }
// // /""""""""""""""""""""""""""""""""/
// //<=== LevelGhostArraySet class <==<
// // \________________________________\





def main {

  var level = readLevel("input_level.txt");

  writeln(level);

  // var lga = new LevelGhostArraySet(level = level);
  // 
  // writeln("");
  // 
  // for grid in level.grids {
  //   writeln("Grid:");
  //   writeln(grid);
  // 
  //   for loc in ghost_locations {
  //     writeln("Ghost domain at ", loc, ": ", lga(grid)(loc).dom );
  //     writeln( lga(grid)(loc).value );
  //     writeln("");
  //   }
  // }

}