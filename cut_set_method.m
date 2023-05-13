%Program to evaluate system reliability using tie-set method
%Step-1: Cut-set diagram
%Step-2: Cut-set diagram
%Step-3: Unreliability = P(C1 U C2 U C3....)
%Step-4: Reliability = 1- Unreliability

clc;
clear;
%Inputs: Incidencematrix and reliability of individual elements
%incidence_matrix = [1 0 1 0 0;
                   % 0 1 0 1 0;
                    %1 0 0 1 1;
                    %0 1 1 0 1];
 %unreliability = [0.02 0.02 0.02 0.02 0.02];
 
 %                   A B C D E F G
 incidence_matrix = [1 0 0 0 0 0 0;
                     0 1 1 0 0 0 0;
                     0 0 0 0 1 1 0;
                     0 1 0 1 0 1 0;
                     0 0 1 1 1 0 0;
                     0 0 0 0 0 0 1];
 unreliability = [0.2 0.2 0.2 0.2 0.2 0.2 0.2];
                 
 sizeof_incidence_matrix = size(incidence_matrix);
 system_unreliability = 0;
 
  % CUT SET DIAGRAM
  com=1;
  row=1;
  cut_set=zeros(1,sizeof_incidence_matrix(2));
 for com=1:sizeof_incidence_matrix(2)
     combinations=combntns(1:sizeof_incidence_matrix(2),com);
     sizeof_combinations=size(combinations);
     %combinations
     if com==1         
         for j=1:sizeof_combinations(1)
             A=1;
             for k=1:sizeof_incidence_matrix(1)
                 if incidence_matrix(k,j)==0
                     A=0;
                 end
             end
             if A==1
                 cut_set(row,j)=1;
                 row=row+1;
             end
         end
     else
         for j=1:sizeof_combinations(1)
             A=1;
             for k=1:sizeof_incidence_matrix(1)
                 B=incidence_matrix(k,combinations(j,1));
                 for l=2:com
                     C=B || incidence_matrix(k,combinations(j,l));
                     B=C;
                 end
                     if B==0
                         A=0;
                     end
             end
             if A==1
                 for m=1:com
                     cut_set(row,combinations(j,m))=1;
                 end
                 %soln=cut_set(row,:)
                 row=row+1;
             end
             
         end
     end
 end
 %cut_set
 
 % minimal cut set
 sizeof_cutset=size(cut_set);
 row=1;
 for n=sizeof_cutset(1):-1:2
     D=1;
     for p = 1:n-1
         check = or(cut_set(n,:),cut_set(p,:));
         if check==cut_set(n,:)
             D=0;
         end
     end
     if D==1
         cut_set1(row,:)=cut_set(n,:);
         row=row+1;
     end
 end
 cut_set1(row,:)=cut_set(1,:);
 sizeof_cut_set1=size(cut_set1);
 %cut_set1
 
 %-------------------------------------------------------------------
 %Tie elements
 for i1 = 1:sizeof_cut_set1(1);
     %if element exists that has to be considered for cut diagram
     element = 1;
     for j1=1:sizeof_cut_set1(2)
         if (cut_set1(i1,j1)==1)
             cut(i1,element)=j1;
             element=element+1;
         end
     end
 end
 min_cutset = cut
 sizeof_cut = size(cut);
 
 % All possible combinations of minimal paths for finding 'UNION'
 com=1;
 for com=1:sizeof_cut(1)
     combinations=combntns(1:sizeof_cut(1),com);
     sizeof_combinations=size(combinations);
     %combinations
     for i2=1:sizeof_combinations(1)
         table=[];
         table=cut(combinations(i2,1),:);
         for j2 = 2:sizeof_combinations(2)
             table = [table,cut(combinations(i2,j2),:)];
         end
         sizeof_table=size(table);
         %Tie elements should be non-zero and non-repeated
         table1=[];
         table1=table;
         sizeof_table1=size(table1);
         table2=[];
         for i3=1:sizeof_table1(2)
             if(table1(1,i3)~=0) %avoid elements that are '0'
                 count=0;
                 for j3=i3:sizeof_table1(2)
                     if(table(1,j3)==table1(1,i3))
                         count=count+1;
                     end
                 end
             if (count==1)  %avoid repetition
                 table2 =[table2,table1(1,i3)];
             end
             end
         end
         table=[];
         table=table2;
         sizeof_table=size(table);
         union_terms=table
         %Reliability of individual tie blocks
         cut_unreliability=1;
         for rel=1:sizeof_table(2)
             cut_unreliability=cut_unreliability * unreliability(table(rel));
         end
         cut_unreliability
         %Reliability of the system
         system_unreliability=system_unreliability+(((-1)^(com+1))*cut_unreliability);
     end
 end
 system_reliability=1-system_unreliability
         
         
     