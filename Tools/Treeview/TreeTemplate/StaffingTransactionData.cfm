
<cfset Mission = URL.Mission>

<cf_UItree id="root" title="<span style='font-size:16px;color:gray;padding-bottom:3px'>#Mission#</span>" expand="Yes">

<cfquery name="Default" 
	datasource="AppsOrganization" 
	maxrows=1 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 MandateNo 
	    FROM   Ref_Mandate
	   	WHERE  Mission    = '#Mission#'
		ORDER BY MandateDefault DESC		
</cfquery>
	  
<cfset MandateDefault = Default.MandateNo>	  
    
<cfoutput>

<cfquery name="Mandate" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT MandateNo, Description, DateEffective, DateExpiration, MandateDefault
      FROM   Ref_Mandate
   	  WHERE  Mission = '#Mission#'
	  ORDER BY DateEffective DESC
  </cfquery>

  <cfloop query="Mandate">
  
  	<cfif MandateDefault eq "1">
	   <cfset exp = "Yes">
	<cfelse>
	   <cfset exp = "No">   
	</cfif>	
	
	  <cf_UItreeitem value="#MandateNo#"
		        display="<span style='font-size:17px;height:20px;padding-top:4px' class='labelit'>#dateformat(Mandate.DateExpiration,client.dateformatshow)#</span>"												
				parent="root" expand="#exp#">				      
     			   
	  <cfset MandateNo = Mandate.MandateNo>
  
	  <cfquery name="Action" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT   DISTINCT R.ActionCode, R.ListingOrder, R.Description, R.ActionSource 
	      FROM     EmployeeAction S, Ref_Action R
		  WHERE    S.ActionCode = R.ActionCode
		  AND      Mission      = '#Mission#'
		  AND      MandateNo    = '#MandateNo#' 
		  ORDER BY R.ActionSource,R.ListingOrder, R.Description 
	  </cfquery>
	  
	   <cf_UItreeitem value="#MandateNo#_inc"
		        display="<span style='font-size:14px' class='labelit'>Inception of the mandate</span>"						
				href="../../Inception/MandateEdit.cfm?ID=#Mission#&ID1=#MandateNo#&Mission=0"		
				target="right"		
				parent="#MandateNo#">	
	  
	  <cf_UItreeitem value="#MandateNo#_dur"
		        display="<span style='font-size:14px' class='labelit'>During the mandate</span>"						
				href="../../Inception/MandateEdit.cfm?ID=#Mission#&ID1=#MandateNo#&Mission=0"		
				target="right"		
				parent="#MandateNo#">	
						
	  <cf_UItreeitem value="#MandateNo#_dur_act"
		        display="<span style='font-size:16px' class='labelit'>Personnel Action</span>"										
				target="right"		
				parent="#MandateNo#_dur">		 		
	 
	  <cfset prior = "">
       
	  <cfloop query="action">
	  
	   <cfif actionsource neq prior>
	   
	     <cfset prior = actionsource>
		 
		  <cf_UItreeitem value="#MandateNo#_dur_act_#prior#"
		        display="<span style='font-size:13px' class='labelit'>#ActionSource#</span>"										
				target="right" expand="No"		
				parent="#MandateNo#_dur_act">		   
	    	   
	   </cfif>
	  
	   <cfset ActionCode = Action.ActionCode>
		  	  		    
		  <cfquery name="ActionStatus" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  
		      SELECT   *, 
			           (SELECT count(DISTINCT ActionDocumentNo) 
					    FROM   EmployeeAction 
						WHERE  Mission    = '#Mission#' 
						AND    MandateNo  = '#MandateNo#' 
						AND    ActionCode = '#ActionCode#' 
						AND    ActionPersonNo is not NULL
						AND    ActionStatus = R.Status) as Counted 
		      FROM     Ref_Status R			 
			  <cfif Action.actionsource eq "Assignment">
			  WHERE    R.Class = 'Assignment'
			  <cfelse>
			  WHERE    R.Class = 'Action'
			  </cfif>			
			  ORDER BY R.Status
			  
		  </cfquery>	
		  
		    <cf_UItreeitem value="#MandateNo#_dur_act_#prior#_#ActionCode#"
		        display="<span style='font-size:13px' class='labelit'>#ActionCode# #Description# [#actionStatus.counted#]</span>"										
				target="right"		
				href="TransactionViewGeneral.cfm?ID=CDE&ID1=#ActionCode#&Mission=#Mission#&ID3=#MandateNo#&ID4=0"
				parent="#MandateNo#_dur_act_#prior#"
				expand="No">			  		  
	
		  <cfloop query="actionstatus">
		  
		  	 <cf_UItreeitem value="#MandateNo#_dur_act_#prior#_#ActionCode#_#Status#"
		        display="<span style='font-size:13px' class='labelit'>#Description# [#counted#]</span>"										
				target="right"		
				href="TransactionViewGeneral.cfm?ID=CDE&ID1=#ActionCode#&Mission=#Mission#&ID3=#MandateNo#&ID4=#Status#"
				parent="#MandateNo#_dur_act_#prior#_#ActionCode#"
				expand="No">			  	 
		 		    
		  </cfloop>
	        
	  </cfloop>
  
  <cfquery name="ActionStatus" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT R.Status, R.Description 
      FROM  Ref_Status R
	  WHERE Class = 'Assignment'	 
	  ORDER BY R.Status
  </cfquery>
  
  <!--- disalbed as the status can be mixed per action 
  
  <cftreeitem value="#MandateNo#_dur_sta"
        display="<b>Approval Status"
		parent="#MandateNo#_dur"				
        expand="Yes">	  
     
	  <cfloop query="actionstatus">
	  
	     <cfset Status = "#ActionStatus.Status#">
	  
	     <cftreeitem value="#MandateNo#_dur_sta_#Status#"
          display="#Description#"
   		  parent="#MandateNo#_dur_sta"	
		  href="TransactionViewGeneral.cfm?ID=STA&ID1=all&Mission=#Mission#&ID3=#MandateNo#&ID4=#Status#"
		  target="right"				
          expand="Yes">	  
	    
		  <cfquery name="Action" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      SELECT DISTINCT R.ActionCode, R.Description 
		      FROM   EmployeeAction S, Ref_Action R
			  WHERE  S.ActionCode = R.ActionCode
			  AND    Mission        = '#Mission#'
			  AND    MandateNo      = '#MandateNo#'
			  AND    S.ActionStatus = '#Status#'
			  ORDER BY R.Description 
		  </cfquery>
	  
			  <cfloop query="action">
			  			    
			   <cftreeitem value="#MandateNo#_dur_sta_#Status#_#ActionCode#"
			        display="#Description#"
					parent="#MandateNo#_dur_sta_#Status#_#ActionCode#"	
					href="TransactionViewGeneral.cfm?ID=STA&ID1=#ActionCode#&Mission=#Mission#&ID3=#MandateNo#&ID4=#Status#"
					target="right"				
			        expand="Yes">	 	
			  			    
			  </cfloop>
	        
	  </cfloop>
	  
  --->  
  
  <cfquery name="Posttype" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT PostType 
      FROM   EmployeeAction 
	  WHERE  Mission = '#Mission#'
	  AND    MandateNo = '#MandateNo#'		
  </cfquery>
  
  <cf_UItreeitem value="#MandateNo#_dur_tpe"
		        display="<span style='font-size:16px' class='labelit'>Post Type</span>"										
				target="right"		
				expand="No"
				parent="#MandateNo#_dur">		 		
      
  <cfloop query="Posttype">
  
     <cfset tpe = "#Posttype.Posttype#">
	 
	  <cf_UItreeitem value="#MandateNo#_dur_tpe_#tpe#"
		        display="<span style='font-size:13px' class='labelit'>#tpe#</span>"										
				target="right"						
				parent="#MandateNo#_dur_tpe"
				expand="Yes">		
        
		  <cfquery name="ActionStatus" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      SELECT DISTINCT R.Status, R.Description 
		      FROM   EmployeeAction S, Ref_Status R
			  WHERE  S.ActionStatus = R.Status
			  AND    R.Class = 'Assignment'
			  AND    Mission = '#Mission#'
			  AND    MandateNo = '#MandateNo#'
			  AND    Posttype = '#tpe#'
			  ORDER BY R.Status
		  </cfquery>
  
			  <cfloop query="actionstatus">
			  
			   <cf_UItreeitem value="#MandateNo#_dur_tpe_#tpe#_#Status#"
		        display="<span style='font-size:13px' class='labelit'>#Description#</span>"										
				target="right"		
				href="TransactionViewGeneral.cfm?ID=TPE&ID1=#tpe#&Mission=#Mission#&ID3=#MandateNo#&ID4=#Status#"
				parent="#MandateNo#_dur_tpe_#tpe#"
				expand="No">	
			  			  
			  </cfloop>
		        
		  </cfloop>
		 		  		  		  
  </cfloop>  
    
</cfoutput>

</cf_UItree>	

 



