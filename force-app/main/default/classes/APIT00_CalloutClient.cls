public without sharing class APIT00_CalloutClient {

	public static String applyQueryString(String pathOrigin, Map<String,String> params){
		String pathReturn = pathOrigin;

		if(params != null && !params.isEmpty()){
			pathReturn += '?';

			Boolean isFirst = true;

			for(String key : params.keySet()){

				if(params.get(key) != null && String.isNotBlank(params.get(key))){

					if(!isFirst) pathReturn += '&';

					pathReturn += key+'='+EncodingUtil.urlEncode(params.get(key),'UTF-8');

					isFirst = false;
				}
			}

			System.debug('APIT00_CalloutClient.getRequest: Get params: ' + params);
		}

		return pathReturn;
	}

	public static String applyParamenters(String pathOrigin, Map<String,String> params){
		if(params == null) return pathOrigin;
		
		for(String paramName : params.keySet()){
			String value = params.get(paramName);

			if(pathOrigin.contains(paramName)){
				pathOrigin = pathOrigin.replace('{' + paramName + '}', value);

				params.remove(paramName);
			}
		}

		return pathOrigin;
	}

}