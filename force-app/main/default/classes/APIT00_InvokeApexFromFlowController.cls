public class APIT00_InvokeApexFromFlowController{
    
    @InvocableMethod(label='Invoke Apex')
    public static List <FlowOutputs> invokeThisMetho(List<FlowInputs> request) {
        List<FlowOutputs> results = new List<FlowOutputs>();
        FlowOutputs result= new FlowOutputs ();
   if (request.size()>0 ) {
   	   result.NewValueString=String.ValueOf(request[0].History.NewValue);
       result.OldValueString=String.ValueOf(request[0].History.OldValue);
        results.add(result);}
        return results;
    }
    
    //input details that comes to apex from flow
    public class FlowInputs{
    
        @InvocableVariable
        public LeadHistory History;
        
    
        
    }
    
    //output details which goes from apex to flow
    public class FlowOutputs{
        
        @InvocableVariable
        public String NewValueString;
        
        @InvocableVariable
        public String OldValueString;
    }
}