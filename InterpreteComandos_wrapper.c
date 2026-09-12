
/*
 * Include Files
 *
 */
#if defined(MATLAB_MEX_FILE)
#include "tmwtypes.h"
#include "simstruc_types.h"
#else
#include "rtwtypes.h"
#endif



/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 1
#define y_width 1

/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */
/* extern double func(double a); */
/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Start function
 *
 */
void InterpreteComandos_Start_wrapper(real_T *xD)
{
/* %%%-SFUNWIZ_wrapper_Start_Changes_BEGIN --- EDIT HERE TO _END */
/*
 * Custom Start code goes here.
 */
xD[0] = 0;
/* %%%-SFUNWIZ_wrapper_Start_Changes_END --- EDIT HERE TO _BEGIN */
}
/*
 * Output function
 *
 */
void InterpreteComandos_Outputs_wrapper(const real_T *comando,
			real_T *salida,
			const real_T *xD)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
/* This sample sets the output equal to the input
      y0[0] = u0[0]; 
 For complex signals use: y0[0].re = u0[0].re; 
      y0[0].im = u0[0].im;
      y1[0].re = u1[0].re;
      y1[0].im = u1[0].im;
 */
salida[0] = xD[0];
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}

/*
 * Updates function
 *
 */
void InterpreteComandos_Update_wrapper(const real_T *comando,
			real_T *salida,
			real_T *xD)
{
/* %%%-SFUNWIZ_wrapper_Update_Changes_BEGIN --- EDIT HERE TO _END */
/*
 * Code example
 *   xD[0] = u0[0];
 */

real_T valorActual = xD[0];
const real_T valorMax = 0.349066;
const real_T desplazamientoMax = valorMax/800.0;
real_T cambio = 0;
if(comando[0]<=-1){ //llevar A inclinaciónMax negativa
    if(valorActual>-valorMax){//disminuirlo
        cambio = -desplazamientoMax;
    }
}else if(comando[0]>=1){ //llevar A inclinaciónMax positia
    if(valorActual<valorMax){//disminuirlo
        cambio = desplazamientoMax;
    }
}else{ //Estado neutral
    if(valorActual>0){//disminuirlo
        cambio = -desplazamientoMax;
    }else if (valorActual<0){
        cambio = desplazamientoMax;
    }
}
xD[0] += cambio;
/* %%%-SFUNWIZ_wrapper_Update_Changes_END --- EDIT HERE TO _BEGIN */
}

