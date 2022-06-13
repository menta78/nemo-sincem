MODULE diawri_off
   !!======================================================================
   !!                     ***  MODULE  diawri  ***
   !! Ocean diagnostics :  write ocean output files
   !!=====================================================================
   !! History :  OPA  ! 1991-03  (M.-A. Foujols)  Original code
   !!            4.0  ! 1991-11  (G. Madec)
   !!                 ! 1992-06  (M. Imbard)  correction restart file
   !!                 ! 1992-07  (M. Imbard)  split into diawri and rstwri
   !!                 ! 1993-03  (M. Imbard)  suppress writibm
   !!                 ! 1998-01  (C. Levy)  NETCDF format using ioipsl INTERFACE
   !!                 ! 1999-02  (E. Guilyardi)  name of netCDF files + variables
   !!            8.2  ! 2000-06  (M. Imbard)  Original code (diabort.F)
   !!   NEMO     1.0  ! 2002-06  (A.Bozec, E. Durand)  Original code (diainit.F)
   !!             -   ! 2002-09  (G. Madec)  F90: Free form and module
   !!             -   ! 2002-12  (G. Madec)  merge of diabort and diainit, F90
   !!                 ! 2005-11  (V. Garnier) Surface pressure gradient organization
   !!            3.2  ! 2008-11  (B. Lemaire) creation from old diawri
   !!----------------------------------------------------------------------

   !!----------------------------------------------------------------------
   !!   dia_wri       : create the standart output files
   !!   dia_wri_state : create an output NetCDF file for a single instantaeous ocean state and forcing fields
   !!----------------------------------------------------------------------
   USE oce             ! ocean dynamics and tracers 
   USE dom_oce         ! ocean space and time domain
   USE dynadv, ONLY: ln_dynadv_vec
   USE zdf_oce         ! ocean vertical physics
   USE ldftra_oce      ! ocean active tracers: lateral physics
   USE ldfdyn_oce      ! ocean dynamics: lateral physics
   USE traldf_iso_grif, ONLY : psix_eiv, psiy_eiv
   USE sol_oce         ! solver variables
   USE sbc_oce         ! Surface boundary condition: ocean fields
   USE sbc_ice         ! Surface boundary condition: ice fields
   USE icb_oce         ! Icebergs
   USE icbdia          ! Iceberg budgets
   USE sbcssr          ! restoring term toward SST/SSS climatology
   USE phycst          ! physical constants
   USE zdfmxl          ! mixed layer
   USE dianam          ! build name of file (routine)
   USE zdfddm          ! vertical  physics: double diffusion
   USE diahth          ! thermocline diagnostics
   USE lbclnk          ! ocean lateral boundary conditions (or mpp link)
   USE in_out_manager  ! I/O manager
   USE diadimg         ! dimg direct access file format output
   USE iom
   USE ioipsl
   USE dynspg_oce, ONLY: un_adv, vn_adv ! barotropic velocities     

#if defined key_lim2
   USE limwri_2 
#elif defined key_lim3
   USE limwri 
#endif
   USE lib_mpp         ! MPP library
   USE timing          ! preformance summary
   USE wrk_nemo        ! working array
   USE diawri

   IMPLICIT NONE
   PRIVATE

   PUBLIC   dia_wri_off  
CONTAINS

   !!----------------------------------------------------------------------
   !!   'key_iomput'                                        use IOM library
   !!----------------------------------------------------------------------

   SUBROUTINE dia_wri_off( kt )
      INTEGER, INTENT( in ) ::   kt      ! ocean time-step index

      CALL iom_put( "toce", tsn(:,:,:,jp_tem) )    ! 3D temperature
      CALL iom_put(  "sst", tsn(:,:,1,jp_tem) )    ! surface temperature
      
      CALL iom_put( "soce", tsn(:,:,:,jp_sal) )    ! 3D salinity
      CALL iom_put(  "sss", tsn(:,:,1,jp_sal) )    ! surface salinity
   END SUBROUTINE dia_wri_off

   !!======================================================================
END MODULE diawri_off
