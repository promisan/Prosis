
<cf_screentop height="100%" scroll="Yes" html="No">

<table width="100%" align="center">

	<tr><td>
		<cfinclude template="../UnitView/UnitViewHeader.cfm">
	</td></tr>
	
</table>

<cfajaximport>

<script>

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld,org,cat){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight2";
	 ColdFusion.navigate('GroupEntrySubmit.cfm?action=insert&orgunit='+org+'&category='+cat,'result')
	 }else{
		
     itm.className = "regular";		
	 ColdFusion.navigate('GroupEntrySubmit.cfm?action=delete&orgunit='+org+'&category='+cat,'result')
	 }
  }
  
  
function expand(itm,icon){
	 
	 se  = document.getElementById(itm)
	 icM  = document.getElementById(itm+"Min")
     icE  = document.getElementById(itm+"Exp")
	 if (se.className == "hide")
	 {
	 se.className = "regular";
	 icM.className = "regular";
	 icE.className = "hide";			
	 }
	 else
	 {
	  se.className = "hide";
	 icM.className = "hide";
	 icE.className = "regular";		
	 }
  }    

</script>

<script language="JavaScript">
	javascript:window.history.forward(1);
</script>


<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mission
	WHERE  Mission IN (SELECT Mission 
	                   FROM   Organization 
					   WHERE  OrgUnit = '#url.id#')
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr class="hide"><td id="result"></td></tr>
<tr><td>

	<cfform action="GroupEntrySubmit.cfm" method="POST" name="groupentry">
	
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
	
	  <tr>
	  	<td height="40" style="padding:4px" class="labellarge"><cf_tl id="Workforce Classification"></b></td>		
		<td align="right"></td>
	  </tr>
	
	  <cfquery name="Master" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT   DISTINCT Area
		  FROM     Ref_OrganizationCategory
		  WHERE    Owner = '#Mission.MissionOwner#'
		  ORDER BY Area
	  </cfquery>
		
	  <cfloop query="Master">
		
		        <cfset ar = Master.Area>
				
				<cfquery name="GroupAll" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
				SELECT F.*, 
				       S.OrgUnit as Selected
				FROM   OrganizationCategory S RIGHT OUTER JOIN Ref_OrganizationCategory F ON S.OrganizationCategory = F.Code
				   AND S.OrgUnit = '#URL.ID#'
				WHERE  F.Area = '#Ar#'
				AND    F.Owner = '#Mission.MissionOwner#'
				</cfquery>
											
	  <tr><td>
						
		   <table width="100%">
					
				<cfoutput>
				
				<TR><td align="left" height="19" class="labelit" style="padding-left:4px">
				
		    		<cfquery name="Check" 
				    datasource="AppsOrganization" 
		   		    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
		    		SELECT S.OrgUnit
				    FROM   OrganizationCategory S, 
				           Ref_OrganizationCategory F
				    WHERE  S.OrgUnit = '#URL.ID#'
				    AND    S.OrganizationCategory = F.Code					
				    AND    F.Area = '#Ar#'
				    </cfquery>
						   
				   <img src="#SESSION.root#/Images/zoomin.jpg" alt="Expand" 
				   id="#Ar#Exp" border="0" class="<cfif Check.recordCount gt "0">hide<cfelse>regular</cfif>" 
				   align="absmiddle" style="cursor: pointer;" onClick="expand('#Ar#')">
				   
				   <img src="#SESSION.root#/Images/zoomout.jpg" 
				    id="#Ar#Min"
				    alt="Hide" border="0" align="absmiddle" class="<cfif Check.recordCount gt "0">regular<cfelse>hide</cfif>" style="cursor: pointer;" 
				   onClick="expand('#Ar#')">
						    		   
					&nbsp;<a href="javascript:expand('#Ar#')">#Ar#</a></td></TR>
					
					</cfoutput>
					
					<tr><td height="1" class="linedotted"></td></tr>
									
		    		<TR><td width="100%">
										
				    <cfoutput>
								
					<cfif Check.recordCount gt "0">
					
		    			<table width="100%" border="0" align="right" id="#Ar#">
					
					<cfelse>
					
			    		<table width="100%" border="0" align="right" class="hide" id="#Ar#">
								
					</cfif>
		
					<tr>
		    			<td width="30" valign="top">&nbsp;<img src="#SESSION.root#/Images/join.gif" alt=""></td>
						<td width="100%">
						<table width="100%" cellspacing="0" cellpadding="0" align="left" style="border:1px dotted silver">
					
							</cfoutput>
						
							<cfoutput query="GroupAll">
												
							<cfif CurrentRow MOD 2><TR></cfif>
								<td width="50%" style="padding:1px">
								<table width="100%" cellspacing="0" cellpadding="0">
									<cfif Selected eq "">
									          <TR class="regular">
									<cfelse>  <TR class="highlight2">
									</cfif>
								   	<TD width="15%" class="labelmedium" style="padding-left:5px;padding-right:10px">#Code#</TD>
								    <TD width="75%" class="labelmedium">#Description#</TD>
									<td width="10%" align="right">
									
									<cfif access eq "EDIT" or access eq "ALL">
									
										<input type="checkbox" 
										   name="category" 
										   id="category"
										   class="radiol"
										   value="#Code#" <cfif Selected neq "">checked</cfif>
										   onClick="hl(this,this.checked,'#url.id#','#code#')">
										
									 
									 </cfif>  
									   
									 </td>
									 </tr>
									
								</table>
								</td>
								
								<cfif GroupAll.recordCount eq "1">
		    						<td width="50%"></td>
								</cfif>
								
							    <cfif CurrentRow MOD 2><cfelse></TR></cfif> 	
							
							</CFOUTPUT>
														
					    </table>
						
						</td></tr>
						
						</table>
											
					</td></tr>
									
				</table>
				
			</td></tr>
				
		</cfloop>		
				
		</table>
		
		</td></tr>
			
	</cfform>

</td></tr>

</table>

</td></tr>

</table>
