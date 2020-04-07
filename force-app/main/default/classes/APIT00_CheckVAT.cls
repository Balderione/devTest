public class APIT00_CheckVAT {
public static boolean ValidatePartitaIVA(string partitaIVA)

        {
boolean ret=true; 
            if(!String.isEmpty(partitaIVA)){
            if(partitaIVA.isNumeric()){
            if (partitaIVA.length() != 11 ){

                ret= false;
}
 

            Long intPartitaIva = 0;

            if (!Pattern.matches('\\d{5}(-\\d{4})?',partitaIVA) ){

                ret= false;
                
            }
intPartitaIva=Long.valueof(partitaIVA) ;
 
                              
            Long sommatore = 0;

            for (integer i = 0; i < partitaIVA.length(); i++)

            {

                if (i == 0 || math.mod(i, 2)== 0)

                {

                    if (i<>0){
                    sommatore += long.valueof(partitaIVA.Substring(i, i+1));
                    //system.debug('test'+long.valueof(partitaIVA.Substring(1, i)));
                }else
                { //system.debug('test'+long.valueof(partitaIVA.Substring(i,1)));
                    sommatore += long.valueof(partitaIVA.Substring(i, i+1));
               
                }

                }

                else

                {
long cifra;
                 if (i<>1){        
                     cifra = long.valueof(partitaIVA.Substring(i, i+1));
               //      system.debug('test'+partitaIVA.Substring(1, i));
                 }else{
           cifra = long.valueof(partitaIVA.Substring(i, i+1));
             //       system.debug('test'+partitaIVA.Substring(i, 2));
                }
                    if (cifra <= 4)

                        sommatore += cifra * 2;

                    else

                        sommatore += ((cifra * 2) + 1) - 10;

                }
system.debug('test'+sommatore);
            }

            if (math.mod(sommatore, 10)!= 0){

                ret= false;
            } else{
             ret= true;
            }
            } else {
                ret = false;
            }
        }
            return ret;
}
}