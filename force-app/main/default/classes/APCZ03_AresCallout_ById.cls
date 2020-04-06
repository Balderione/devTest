public class APCZ03_AresCallout_ById {
    
    public HttpResponse getDarvBas(String sId) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        //24745391 Edenred
        req.setEndpoint('http://wwwinfo.mfcr.cz/cgi-bin/ares/darv_bas.cgi?ico=' + sId);
        
        req.setMethod('GET');
        HttpResponse res = h.send(req);
                
        return res;
    }//darv_bas
    
        public HttpResponse getDarvRes(String sId) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        //24745391 Edenred
        req.setEndpoint('http://wwwinfo.mfcr.cz/cgi-bin/ares/darv_res.cgi?ico=' + sId);
        
        req.setMethod('GET');
        HttpResponse res = h.send(req);
                
        return res;
    }//darv_res

}