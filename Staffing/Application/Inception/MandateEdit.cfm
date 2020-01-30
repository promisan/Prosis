
<cf_calendarscript>
<cf_dialogPosition>
<cfajaximport tags="cfwindow">

<cfquery name="Current" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Mission
  WHERE  Mission = '#URL.ID#'
</cfquery>

<cfquery name="Get" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Mandate
	WHERE MandateNo = '#URL.ID1#'
	AND   Mission   = '#URL.ID#'
</cfquery>

<cfquery name="GetParent" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mandate
	WHERE  MandateNo = '#Get.MandateParent#'
	AND    Mission   = '#URL.ID#'
</cfquery>

<cfquery name="GetParameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.ID#'
</cfquery>

<cfoutput>
	
	<script>
		
		w = 0
		h = 0
		if (screen) {
		w = #CLIENT.width# - 60
		h = #CLIENT.height# - 140
		}
		
		function ask() {
			if (confirm("Do you want to remove this mandate ?")) {	
			return true 	
			}	
			return false
			
		}	
		
		function recopy() {
		
		   try { ColdFusion.Window.destroy('recopy',true) } catch(e) {}
		   ColdFusion.Window.create('mydialog', 'recopy', '',{x:100,y:100,height:document.body.clientHeight-100,width:document.body.clientWidth-100,modal:true,resizable:false,center:true})    						
		   ColdFusion.navigate('RecopyAssignmentDialog.cfm?mission=#URL.ID#&mandateparent=#GetParent.MandateNo#&mandateNo=#URL.ID1#','mydialog')  
			
		}
		
		function extend() {	   
			ColdFusion.navigate('RecopyAssignmentGo.cfm?mission=#URL.ID#&MandateParent=#GetParent.MandateNo#&MandateNo=#URL.ID1#&onlynew='+document.getElementById('onlynew').checked+'&extend='+document.getElementById('extendfirst').checked,'processbox')
		}
		
		function transform(docno) {
		 	window.open("TransformView/TransformView.cfm?ID=#URL.ID#&ID1=#URL.ID1#&ID4=" + docno,  "madatescreen", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=no");
		}
		
		
		function mandate() {
		    
			try { ColdFusion.Window.destroy('mydialog',true) } catch(e) {}
			ColdFusion.Window.create('mydialog', 'Mandate', '',{x:100,y:100,height:document.body.clientHeight-100,width:document.body.clientWidth-100,modal:true,resizable:false,center:true})    						
			ColdFusion.navigate('MandateView.cfm?ID=#URL.ID#&ID1=#URL.ID1#','mydialog')  
		}
		
		function PrintCustom(ad) {
			window.open("#SESSION.root#/#GetParameter.PersonActionTemplate#?ID=#URL.ID#&ID1=#URL.ID1#&ID2="+ad)
		}
	
	</script>

</cfoutput>

<cfinvoke component="Service.Access"  
         method="org" 
		 mission="#URL.ID#" 
		 mandateNo="#URL.ID1#"
		 returnvariable="orgaccess">
		 
<cf_screentop height="100%" scroll="Yes" html="No" layout="innerbox" title="#Get.Mission# Staffing period">		 

<cfform action="MandateEditSubmit.cfm" method="POST" name="mandateform">

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

  <cfoutput>  
  
  <tr><td height="5"></td></tr>     
  
  <tr class="line labelmedium"><td colspan="2" style="font-weight:200;height:50px;font-size:28px">Maintain Staffing Period #Get.MandateNo#</td></tr>   
  
  <tr><td height="5"></td></tr>
  <tr>
    <td width="100%" colspan="2">	
	
    <table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding">
			
	<cfif getParent.Description neq "">
	
		<tr class="labelmedium">
		<td style="padding-left:3px">Parent Period:</td>
		<td>#getParent.Description#<input type="hidden" name="MandateParent" value="#GetParent.MandateNo#"></td>
		</TR>	
		
		<cfif orgAccess eq "READ" or orgAccess eq "EDIT" or orgAccess eq "ALL"> 
		
			<cfif get.MandateStatus eq "0">
			<tr>
			<td></td>
			<td>
				<table>
					<tr><td class="labelmedium">
					You can reinitialize this staffing period by carrying over the ASSIGNMENTS that were valid by the end of the prior (parent)	mandate.
					</td></tr>
					<tr><td id="boxcopy">
					
					<cfset url.mission   = url.id>
					<cfset url.mandateno = url.id1>
					<cfinclude template="RecopyAssignmentResult.cfm">
					
					</td></tr>
					<tr><td  height="30" class="labelmedium">
					    <a href="javascript:recopy()"><font color="0080C0">Recopy Assignments and Contracts</a>				
					</td></tr>
				</table>				
			</td>
			</tr>
			</cfif>	
		
		</cfif>
	
	</cfif>		
			
	
	<tr class="labelmedium">
    <td style="padding-left:3px">Name:</td>
	<td><cfinput type="Text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="30" maxlength="40" class="regularxl">
		<input  type="hidden" name="mission"       value="#Get.Mission#">
		<input type="hidden" name="mandatestatus"  value="#Get.MandateStatus#">
		<input type="hidden" name="mandateno" value="#Get.MandateNo#">
	</td>
	</TR>	
	
	<tr class="labelmedium"> 		
		<TD style="padding-left:3px">Effective:</td>
    
		<td>
		
		<table cellspacing="0" cellpadding="0"><tr><td>
		   <input type="hidden" name="DateEffectiveOld" value="#Dateformat(Get.DateEffective, CLIENT.DateFormatShow)#"> 
	   	   	<cf_intelliCalendarDate9
			FieldName="DateEffective" 
			class="regularxl"
			Default="#Dateformat(Get.DateEffective, CLIENT.DateFormatShow)#"
			AllowBlank="False">	
		</td>
		<TD style="padding-left:15px"><font face="Calibri" size="2">Expiration:</td>
    
		<td style="padding-left:3px"><input type="hidden" name="DateExpirationOld" value="#Dateformat(Get.DateExpiration, CLIENT.DateFormatShow)#"> 
	   	   	<cf_intelliCalendarDate9
			FieldName="DateExpiration" 
			class="regularxl"
			Default="#Dateformat(Get.DateExpiration, CLIENT.DateFormatShow)#"
			AllowBlank="False">	
		</td>
		</tr>
		</table>
	</TR>
					
	<cfquery name="Pos" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT count(*) as Total
		FROM   PositionParent
		WHERE  MandateNo = '#URL.ID1#'
		AND    Mission   = '#URL.ID#'
	</cfquery>
	
	<cfif get.DateEffective lte now() AND get.DateExpiration gte now()>
	 <cfset cur = "1">	 
	<cfelse>
	 <cfset cur = "0">
	</cfif>
	
	<cfquery name="ValidPosition" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT count(*) as Total
		FROM  Position
		WHERE MandateNo = '#URL.ID1#'
		AND   Mission   = '#URL.ID#'
		<cfif cur eq "1">		
		AND   DateExpiration >= getDate()
		<cfelse>
		AND   DateExpiration = '#Get.DateExpiration#'
		</cfif>
	</cfquery>
		
	<cfquery name="ValidAssignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT count(*) as Total
		FROM  PersonAssignment
		WHERE PositionNo IN (SELECT PositionNo
		                    FROM  Position
							WHERE MandateNo = '#URL.ID1#'
							AND   Mission   = '#URL.ID#'
							<cfif cur eq "1">
							AND   DateExpiration >= getDate()
							AND   DateEffective  < getDate()
							<cfelse>
							AND   DateExpiration = '#Get.DateExpiration#'
							</cfif>
		                    )
		AND   AssignmentStatus IN ('0','1')
		<cfif cur eq "1">
		AND   DateExpiration >= getDate()
		AND   DateEffective < getDate()
		<cfelse>
		AND   DateExpiration = '#Get.DateExpiration#'
		</cfif>
		
	</cfquery>
		
	<tr class="labelmedium line"> 		
		<TD valign="top" style="padding-top:6px;padding-left:3px">Summary:</td>    
		
		<td>
		   <table cellspacing="0" cellpadding="0" class="formpadding">
		   <tr class="labelmedium">
		    <td>Total Positions:</td>
			<td style="padding-left:10px"><b>#numberformat(Pos.Total,'__,__')#</td>
			<td style="padding-left:20px">As per <cfif cur eq "1">#dateformat(now(),CLIENT.DateFormatShow)#<cfelse>#dateformat(Get.DateExpiration,CLIENT.DateFormatShow)#</cfif></td>
			<td style="padding-left:5px">Positions:</td>
			<td style="padding-left:10px" align="right"><font color="000000">#numberformat(ValidPosition.Total,'__,__')#</td>
			<td style="padding-left:5px">Assignments:</td>
			<td  style="padding-left:10px" align="right">#numberformat(ValidAssignment.Total,'__,__')#</td>
		   </tr>			   
		   </table>
		</td>		
	</TR>
		
	<tr class="labelmedium line"> 		
		<TD style="padding-left:3px;padding-right:5px;height:40px">is&nbsp;Default&nbsp;Period:</td>
    	<td><input class="radiol" type="checkbox" name="MandateDefault" <cfif Get.MandateDefault eq "1">checked</cfif> value="1">
	</td>
	</TR>
				
	<tr class="labelmedium"> 		
		<TD height="24" style="padding-left:3px" class="labelmedium">Status:</td>
		
		<td>
		 <table>
		 
		  <tr>
		  <td id="status">
		  	 <cfif Get.MandateStatus eq "1">
		      <table cellspacing="0" cellpadding="0" class="formpadding">
			  <tr class="labelmedium"> 	
			  <td>
			      Approved/Locked</font>			  
				  <cfif OrgAccess eq "ALL" and Current.MissionType neq "Template">
				  <br>
				  <a href="javascript:ColdFusion.navigate('MandateOpen.cfm?mission=#url.id#&mandateno=#url.id1#','status')">
				  <font color="0080FF">Click here to [Unlock This Staffing period]</font>
				  </a>
				  </cfif>		  
			  
			  </td>
			  <td style="padding-left:30px"></td>
			  <td><b>Attention:</b><br>Unlocking a mandate should only be done if you know what you are doing!</font></td>
			  </tr>			  
			  </table>
			 </cfif> 
		  </td>		  
		  </tr>
		      	
		  <cfif Get.MandateStatus eq "0" and Current.MissionType neq "Template" and (OrgAccess eq "EDIT" or OrgAccess eq "ALL")>
		     <tr>
			 <td>				 
				 <table cellspacing="0" cellpadding="0" class="formpadding">					
				 <tr class="labelmedium"><td>
		   		 <input class="button10g" style="width:300px;height:21" type="button" name="process" value="Process and/or Lock Mandate" onClick="mandate()">&nbsp;
				 </td></tr>
				 </table>
			 </td>
			 </tr>
		  </cfif>	
		  
		  </table>	
				
	    </td>
	</TR>
			
	<tr><td height="1" colspan="2" class="line"></td></tr>
		
	</cfoutput>	
	
	<tr>
	
		<td height="10" colspan="1" valign="top">
			<table>
			<tr class="labelmedium"><td height="21" style="padding-left:2px">Snapshot :</td></tr>
			</table>
		</td>		
		<td height="10" colspan="1">
			
			<table border="0">
			
			<tr><td>
	
				<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
				
				<cfoutput>
			
					<cfloop index="itm" from="1" to="20" step="1">
					
						<cfquery name="Snapshot" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT *
						FROM Ref_MandateView
						WHERE MandateNo = '#URL.ID1#'
						AND   Mission = '#URL.ID#'
						AND SnapshotOrder = '#Itm#'
						</cfquery>
						
						<cfif itm Mod 2><tr></cfif>
										
							<td class="labelmedium">#itm#:</td>
							<td>
							
							<cf_space spaces="40">
							
						 	   	<cf_intelliCalendarDate9
								class="regularxl"
								FieldName="SnapshotDate#itm#" 
								Default="#dateformat(Snapshot.SnapshotDate, CLIENT.DateFormatShow)#"
								DateValidStart="#Dateformat(get.DateEffective, 'YYYYMMDD')#"
								DateValidEnd="#Dateformat(get.dateExpiration, 'YYYYMMDD')#"
								AllowBlank="true">	
								
							</td>	
							
							<td style="padding-left:3px;padding-right:4px" class="labelit">Nme:</td>
							
							<td style="padding-right:3px">				
					    	 <input type="Text" name="SnapshotLabel#itm#" value="#Snapshot.SnapshotLabel#" message="Please enter a description" size="20" maxlength="20" class="regularxl">				
							</td>
										
						<cfif not itm Mod 2></tr></cfif>				
						
					</cfloop>
					
				</cfoutput>
				
				</table>
								
			</td></tr>
			</table>
						
		</td></tr>
		
		<tr class="line"><td height="1" colspan="2"></td></tr>
	
		<tr> 		
			<td colspan="2">
			
			 <cf_filelibraryN
				DocumentPath="Mission"
				SubDirectory="#URL.ID#" 
				Filter="#Get.MandateNo#"
				Insert="yes"
				Remove="yes"
				ShowSize="yes">	
	    	
		    </td>
		</TR>
				
		<tr><td width="100%" colspan="2">		    
			<cfinclude template="MandateEditLines.cfm">		
	    </td></tr>
	
   <tr><td height="5" colspan="2"></td></tr>	
   
   <tr><td colspan="2" align="center">
   
   <cfif orgAccess eq "EDIT" or orgAccess eq "ALL"> 
				 
	 <input class="button10g"  type="submit" name="cancel" value="Back">
	
		<cfquery name="Check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_Mandate
			WHERE  Mission = '#URL.ID#'
		</cfquery>
			
	<cfif Check.recordcount gt "1">
	    
		<cfif Get.MandateStatus eq "0" or getAdministrator(url.id1) eq "1">
		
			<input class   = "button10g" 
			       type    = "submit" 
				   name    = "Delete" 
				   value   = "Purge" 
				   onclick = "return ask()">
				   
		</cfif>
	</cfif>
	
	<input class = "button10g"  
	       type  = "submit" 
		   name  = "Update" 
		   value = "Update">
	
   </cfif>				
	   
   </td></tr>
   
   <tr><td height="3" colspan="2"></td></tr>	

   </table>
    
   </td></tr>
 
</table>

				
</CFFORM>
