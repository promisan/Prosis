		
	<cfquery name="Update" 
	 datasource="appsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     UPDATE  ClaimLineDSA 
		 SET     ClaimRequestLineNo = '#URL.ClaimRequestLineNo#',
		         MatchingAction     = 1
	     WHERE   TransactionNo      = '#URL.TransactionNo#'
	</cfquery>	
	
		
	 <cfquery name="DSA" 
		datasource="appsTravelClaim" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
    	    SELECT   *
			FROM     ClaimRequestDSA D, Ref_PayrollLocation R
			WHERE    D.ClaimRequestId     = '#URL.ClaimRequestId#'
			AND      D.ClaimRequestLineNo = '#URL.ClaimRequestLineNo#'
			AND      D.ServiceLocation = R.LocationCode 
	</cfquery>
	 
	 <div style="height:15;overflow-y: auto;">	
					
	 <cfoutput query = "DSA">
	 
	 	  <font color="0080C0">#DSA.DSALineNo#.&nbsp; 
	    #DateFormat(DSA.DateEffective, CLIENT.DateFormatShow)# - #DateFormat(DSA.DateExpiration, CLIENT.DateFormatShow)# #DSA.ServiceLocation#-#DSA.Description# <br>
					 				 
	 </cfoutput>
	 
	 </div>
		
