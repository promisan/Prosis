
 <cfswitch expression="#AccessLevel#">
 
	 <cfcase value="0">
	      <CFSET AccessRight = "READ">
	 </cfcase>
		 
	 <cfcase value="1">         
	      <CFSET AccessRight = "EDIT">
	 </cfcase>
		 
	 <cfcase value="2">
	      <CFSET AccessRight = "ALL">
	 </cfcase>
	 
	  <cfcase value="3">
	      <CFSET AccessRight = "ALL">
	 </cfcase>
		 
	  <cfcase value="4">
	      <CFSET AccessRight = "ALL">
	 </cfcase>
	 
	 <cfcase value="9">
	      <CFSET AccessRight = "NONE">
	 </cfcase>
	 
	 <cfdefaultcase>	 
	      <CFSET AccessRight = "NONE">		  
	 </cfdefaultcase>
		 
 </cfswitch>