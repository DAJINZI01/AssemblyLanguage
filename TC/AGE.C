/* calculation of interest for calculated period */

# include <stdio.h>
# include <conio.h>

main()
{
int p_d,p_m,p_y,b_d,b_m,b_y,d_m,d_d,d_y,total,period;
float interest ,amt;
   /*Decleration of date month year */

/* accept first and last date */
 clrscr();
printf("Enter present date (ddmmyyyy)\n ");
scanf("%d%d%d",&p_d,&p_m,&p_y);
printf("enter loan date (ddmmyyyy) \n");
scanf("%d%d%d",&b_d,&b_m,&b_y);
printf("enter the amount \n");
scanf("%f",&amt);

/* Calculation of age */

if (p_d<b_d)
{
p_m--;
p_d+=30;
d_d=p_d-b_d;
}
else
{
d_d=p_d-b_d;
}

if(p_m<b_m)
{
p_y--;
p_m+=12;
d_m=p_m-b_m;
}
else
{
d_m=p_m-b_m;
}

d_y=p_y-b_y;
/* Print the Age */
printf(" \n\n The period is %d years %d months %d days \n\n\n",d_y,d_m,d_d);
period=(d_y*12)+d_m;
if(d_d>0)
period++;
printf("number of months = %d \n\n \n",period);
interest=(period*amt*0.02);
printf("interest= %.2f \n\n\n",interest);
printf("total amount payable = %.2f \n\n\n",amt+interest);
printf("press any key to exit \n");
getch();
}