main()
{
int a,b,sum,dif,mult,div,option;
clrscr();
printf("WELCOME TO SIMPLE CALCULATOR BY BALAJI\n");
printf("enter any two values\n");
scanf("%d%d",&a,&b);
printf("select the operation to be performed \n 1:add \n 2:subtract \n 3:multiply \n 4:divide\n enter the option\n");
scanf("%d",&option);
if (option==1)
{
sum=a+b;
printf("the sum is %d",sum);
}
if (option==2)
{
dif=a-b;
printf("the difference is %d",dif);
}
if (option==3)
{
mult=a*b;
printf("the multiplied answer is %d",mult);
}
if (option==4)
{
div=a/b;
printf("the divided answer is %d",div);
}
getch();
}