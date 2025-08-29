<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
		
