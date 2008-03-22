        MODULE MPI1__<type>_sv
        IMPLICIT NONE
        PRIVATE
        PUBLIC :: MPI_SENDRECV
        INTERFACE MPI_SENDRECV
          MODULE PROCEDURE MPI_SENDRECV_T
        END INTERFACE ! MPI_SENDRECV

        PUBLIC :: MPI_ALLGATHER
        INTERFACE MPI_ALLGATHER
          MODULE PROCEDURE MPI_ALLGATHER_T
        END INTERFACE ! MPI_ALLGATHER

        PUBLIC :: MPI_ALLGATHERV
        INTERFACE MPI_ALLGATHERV
          MODULE PROCEDURE MPI_ALLGATHERV_T
        END INTERFACE ! MPI_ALLGATHERV

        PUBLIC :: MPI_ALLREDUCE
        INTERFACE MPI_ALLREDUCE
          MODULE PROCEDURE MPI_ALLREDUCE_T
        END INTERFACE ! MPI_ALLREDUCE

        PUBLIC :: MPI_ALLTOALL
        INTERFACE MPI_ALLTOALL
          MODULE PROCEDURE MPI_ALLTOALL_T
        END INTERFACE ! MPI_ALLTOALL

        PUBLIC :: MPI_ALLTOALLV
        INTERFACE MPI_ALLTOALLV
          MODULE PROCEDURE MPI_ALLTOALLV_T
        END INTERFACE ! MPI_ALLTOALLV

        PUBLIC :: MPI_GATHER
        INTERFACE MPI_GATHER
          MODULE PROCEDURE MPI_GATHER_T
        END INTERFACE ! MPI_GATHER

        PUBLIC :: MPI_GATHERV
        INTERFACE MPI_GATHERV
          MODULE PROCEDURE MPI_GATHERV_T
        END INTERFACE ! MPI_GATHERV

        PUBLIC :: MPI_REDUCE
        INTERFACE MPI_REDUCE
          MODULE PROCEDURE MPI_REDUCE_T
        END INTERFACE ! MPI_REDUCE

        PUBLIC :: MPI_REDUCE_SCATTER
        INTERFACE MPI_REDUCE_SCATTER
          MODULE PROCEDURE MPI_REDUCE_SCATTER_T
        END INTERFACE ! MPI_REDUCE_SCATTER

        PUBLIC :: MPI_SCAN
        INTERFACE MPI_SCAN
          MODULE PROCEDURE MPI_SCAN_T
        END INTERFACE ! MPI_SCAN

        PUBLIC :: MPI_SCATTER
        INTERFACE MPI_SCATTER
          MODULE PROCEDURE MPI_SCATTER_T
        END INTERFACE ! MPI_SCATTER

        PUBLIC :: MPI_SCATTERV
        INTERFACE MPI_SCATTERV
          MODULE PROCEDURE MPI_SCATTERV_T
        END INTERFACE ! MPI_SCATTERV

        CONTAINS
!
        SUBROUTINE MPI_SENDRECV_T(SENDBUF, SENDCOUNT, SENDTYPE, DEST,  &
      &   SENDTAG, RECVBUF, RECVCOUNT, RECVTYPE, SOURCE, RECVTAG,      &
      &   COMM, STATUS, IERROR) 
        USE MPI_CONSTANTS,ONLY: MPI_STATUS_SIZE
        <type> SENDBUF, RECVBUF(*) 
        INTEGER  SENDCOUNT, SENDTYPE, DEST, SENDTAG, RECVCOUNT,        &
      &   RECVTYPE, SOURCE, RECVTAG, COMM, STATUS(MPI_STATUS_SIZE),    &
      &   IERROR 
        EXTERNAL MPI_SENDRECV
        CALL MPI_SENDRECV(SENDBUF, SENDCOUNT, SENDTYPE, DEST, SENDTAG, &
      &   RECVBUF, RECVCOUNT, RECVTYPE, SOURCE, RECVTAG, COMM, STATUS, &
      &   IERROR) 
        END SUBROUTINE MPI_SENDRECV_T
!
        SUBROUTINE MPI_ALLGATHER_T(SENDBUF, SENDCOUNT, SENDTYPE,       &
      &   RECVBUF, RECVCOUNT, RECVTYPE, COMM, IERROR) 
        <type> SENDBUF, RECVBUF(*) 
        INTEGER SENDCOUNT, SENDTYPE, RECVCOUNT, RECVTYPE, COMM, IERROR
        EXTERNAL MPI_ALLGATHER
        CALL MPI_ALLGATHER(SENDBUF, SENDCOUNT, SENDTYPE, RECVBUF,      &
      &   RECVCOUNT, RECVTYPE, COMM, IERROR) 
        END SUBROUTINE MPI_ALLGATHER_T
!
        SUBROUTINE MPI_ALLGATHERV_T(SENDBUF, SENDCOUNT, SENDTYPE,      &
      &   RECVBUF, RECVCOUNTS, DISPLS, RECVTYPE, COMM, IERROR) 
        <type> SENDBUF, RECVBUF(*) 
        INTEGER SENDCOUNT, SENDTYPE, RECVCOUNTS(*), DISPLS(*),         &
      &   RECVTYPE, COMM, IERROR 
        EXTERNAL MPI_ALLGATHERV
        CALL MPI_ALLGATHERV(SENDBUF, SENDCOUNT, SENDTYPE, RECVBUF,     &
      &   RECVCOUNTS, DISPLS, RECVTYPE, COMM, IERROR) 
        END SUBROUTINE MPI_ALLGATHERV_T
!
        SUBROUTINE MPI_ALLREDUCE_T(SENDBUF, RECVBUF, COUNT, DATATYPE,  &
      &   OP, COMM, IERROR) 
        <type> SENDBUF, RECVBUF(*) 
        INTEGER COUNT, DATATYPE, OP, COMM, IERROR
        EXTERNAL MPI_ALLREDUCE
        CALL MPI_ALLREDUCE(SENDBUF, RECVBUF, COUNT, DATATYPE, OP,      &
      &   COMM, IERROR) 
        END SUBROUTINE MPI_ALLREDUCE_T
!
        SUBROUTINE MPI_ALLTOALL_T(SENDBUF, SENDCOUNT, SENDTYPE,        &
      &   RECVBUF, RECVCOUNT, RECVTYPE, COMM, IERROR) 
        <type> SENDBUF, RECVBUF(*) 
        INTEGER SENDCOUNT, SENDTYPE, RECVCOUNT, RECVTYPE, COMM, IERROR
        EXTERNAL MPI_ALLTOALL
        CALL MPI_ALLTOALL(SENDBUF, SENDCOUNT, SENDTYPE, RECVBUF,       &
      &   RECVCOUNT, RECVTYPE, COMM, IERROR) 
        END SUBROUTINE MPI_ALLTOALL_T
!
        SUBROUTINE MPI_ALLTOALLV_T(SENDBUF, SENDCOUNTS, SDISPLS,       &
      &   SENDTYPE, RECVBUF, RECVCOUNTS, RDISPLS, RECVTYPE, COMM,      &
      &   IERROR) 
        <type> SENDBUF, RECVBUF(*) 
        INTEGER SENDCOUNTS(*), SDISPLS(*), SENDTYPE, RECVCOUNTS(*),    &
      &   RDISPLS(*), RECVTYPE, COMM, IERROR 
        EXTERNAL MPI_ALLTOALLV
        CALL MPI_ALLTOALLV(SENDBUF, SENDCOUNTS, SDISPLS, SENDTYPE,     &
      &   RECVBUF, RECVCOUNTS, RDISPLS, RECVTYPE, COMM, IERROR) 
        END SUBROUTINE MPI_ALLTOALLV_T
!
        SUBROUTINE MPI_GATHER_T(SENDBUF, SENDCOUNT, SENDTYPE, RECVBUF, &
      &   RECVCOUNT, RECVTYPE, ROOT, COMM, IERROR) 
        <type> SENDBUF, RECVBUF(*) 
        INTEGER SENDCOUNT, SENDTYPE, RECVCOUNT, RECVTYPE, ROOT, COMM,  &
      &   IERROR 
        EXTERNAL MPI_GATHER
        CALL MPI_GATHER(SENDBUF, SENDCOUNT, SENDTYPE, RECVBUF,         &
      &   RECVCOUNT, RECVTYPE, ROOT, COMM, IERROR) 
        END SUBROUTINE MPI_GATHER_T
!
        SUBROUTINE MPI_GATHERV_T(SENDBUF, SENDCOUNT, SENDTYPE,         &
      &   RECVBUF, RECVCOUNTS, DISPLS, RECVTYPE, ROOT, COMM, IERROR) 
        <type> SENDBUF, RECVBUF(*) 
        INTEGER SENDCOUNT, SENDTYPE, RECVCOUNTS(*), DISPLS(*),         &
      &   RECVTYPE, ROOT, COMM, IERROR 
        EXTERNAL MPI_GATHERV
        CALL MPI_GATHERV(SENDBUF, SENDCOUNT, SENDTYPE, RECVBUF,        &
      &   RECVCOUNTS, DISPLS, RECVTYPE, ROOT, COMM, IERROR) 
        END SUBROUTINE MPI_GATHERV_T
!
        SUBROUTINE MPI_REDUCE_T(SENDBUF, RECVBUF, COUNT, DATATYPE, OP, &
      &   ROOT, COMM, IERROR) 
        <type> SENDBUF, RECVBUF(*) 
        INTEGER COUNT, DATATYPE, OP, ROOT, COMM, IERROR
        EXTERNAL MPI_REDUCE
        CALL MPI_REDUCE(SENDBUF, RECVBUF, COUNT, DATATYPE, OP, ROOT,   &
      &   COMM, IERROR) 
        END SUBROUTINE MPI_REDUCE_T
!
        SUBROUTINE MPI_REDUCE_SCATTER_T(SENDBUF, RECVBUF, RECVCOUNTS,  &
      &   DATATYPE, OP, COMM, IERROR) 
        <type> SENDBUF, RECVBUF(*) 
        INTEGER RECVCOUNTS(*), DATATYPE, OP, COMM, IERROR
        EXTERNAL MPI_REDUCE_SCATTER
        CALL MPI_REDUCE_SCATTER(SENDBUF, RECVBUF, RECVCOUNTS,          &
      &   DATATYPE, OP, COMM, IERROR) 
        END SUBROUTINE MPI_REDUCE_SCATTER_T
!
        SUBROUTINE MPI_SCAN_T(SENDBUF, RECVBUF, COUNT, DATATYPE, OP,   &
      &   COMM, IERROR) 
        <type> SENDBUF, RECVBUF(*) 
        INTEGER COUNT, DATATYPE, OP, COMM, IERROR
        EXTERNAL MPI_SCAN
        CALL MPI_SCAN(SENDBUF, RECVBUF, COUNT, DATATYPE, OP, COMM,     &
      &   IERROR) 
        END SUBROUTINE MPI_SCAN_T
!
        SUBROUTINE MPI_SCATTER_T(SENDBUF, SENDCOUNT, SENDTYPE,         &
      &   RECVBUF, RECVCOUNT, RECVTYPE, ROOT, COMM, IERROR) 
        <type> SENDBUF, RECVBUF(*) 
        INTEGER SENDCOUNT, SENDTYPE, RECVCOUNT, RECVTYPE, ROOT, COMM,  &
      &   IERROR 
        EXTERNAL MPI_SCATTER
        CALL MPI_SCATTER(SENDBUF, SENDCOUNT, SENDTYPE, RECVBUF,        &
      &   RECVCOUNT, RECVTYPE, ROOT, COMM, IERROR) 
        END SUBROUTINE MPI_SCATTER_T
!
        SUBROUTINE MPI_SCATTERV_T(SENDBUF, SENDCOUNTS, DISPLS,         &
      &   SENDTYPE, RECVBUF, RECVCOUNT, RECVTYPE, ROOT, COMM, IERROR) 
        <type> SENDBUF, RECVBUF(*) 
        INTEGER SENDCOUNTS(*), DISPLS(*), SENDTYPE, RECVCOUNT,         &
      &   RECVTYPE, ROOT, COMM, IERROR 
        EXTERNAL MPI_SCATTERV
        CALL MPI_SCATTERV(SENDBUF, SENDCOUNTS, DISPLS, SENDTYPE,       &
      &   RECVBUF, RECVCOUNT, RECVTYPE, ROOT, COMM, IERROR) 
        END SUBROUTINE MPI_SCATTERV_T
        END MODULE MPI1__<type>_sv
