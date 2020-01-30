
<cf_tl id="Please enter the relative weight of this activity" var="1" class="message">
<cfset msg4="#lt_text#">

<cfoutput>

	<!--- select activities that are dependent on the completion of this activity --->
	
	<cfquery name="ActionParent" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *	
		FROM     ProgramActivity
		WHERE    ProgramCode = '#EditActivity.ProgramCode#'
		<!--- exclude the activities for which it is a parent directly or indirectly --->
		AND      ActivityId IN (SELECT ActivityId
							    FROM   ProgramActivityParent
							    WHERE  ActivityParent = '#URL.ActivityID#'
								AND    ActivityId  != '#URL.ActivityID#') 
							
		AND      RecordStatus != '9'					
		ORDER BY ActivityDateStart
	</cfquery>
	
	<cfif ActionParent.recordcount gt "0">
		
	    <!--- Field: Period --->
	    <TR>
		
	    <td height="24" class="labelmedium" valign="top" style="padding-top:4px">			
			<cf_tl id="Dependent Activities">:
		</td>
		
	    <TD colspan="3" height="24">	
			  
		   <table border="0" width="100%" class="navigation_table">
		   
			   <tr class="labelmedium line">
				   <td width="1%"></td>
				   <td width="50%"><cf_tl id="Activity"></td>
				   <td width="15%"><cf_tl id="Location"></td>
				   <td width="12%"><cf_tl id="Start"></td>
				   <td width="12%"><cf_tl id="Estimated End"></td>
				   <td width="10%"><cf_tl id="Dur"></td>
			   </tr>
			   				
			   <cfloop query="ActionParent">
				  	   
				   <tr class="navigation_row labelmedium">
					   <td style="padding-left:3px;padding-right:5px">					  
						   <cfif ProgramAccess eq "ALL" or completed eq "0">			   	
						  	   <input type="checkbox" 
							       class="enterastab" 
								   style="height:15;width:15" 
								   name="children" 
								   value="#ActivityId#" checked 
								   onClick="hl(this,this.checked)">			
							<cfelse>
								<input type="hidden" name="children" value="#ActivityId#">	   	   
						   </cfif>
					   </td>
				   	   <td>#ActivityDescriptionShort#</td>
					   <td>#LocationCode#</td>
					   <td>#DateFormat(ActivityDateStart,CLIENT.DateFormatShow)#</td>
					   <td>#DateFormat(ActivityDate,CLIENT.DateFormatShow)#</td>
					   <td>#ActivityDays#</td>
				   </tr>	
				      
				</cfloop>
			   
			   </td>
			   </tr>
		   
		   </table>
		</TD>
		</TR>
	
	</cfif>
		
	<!--- Field: Organization--->
	
	<TR>
	    <TD class="labelmedium"><cf_tl id="Responsible Unit">:</TD>
				
	    <TD class="labelmedium" colspan="3">
						
			<cfif ProgramAccess eq "ALL" or completed eq "0">
			
			    <table cellspacing="0" cellpadding="0"><tr><td>
				<input type="text" name="orgunitname" id="orgunitname" value="#EditActivity.OrgUnitName#" class="regularxl enterastab" size="80" maxlength="80" readonly>
				</td>
				<td style="padding-left:3px">
				<input name="btnFunction" class="button10g enterastab" type="button" style="border-radius:2px;height:25;width:25" onClick="selectorgmisn('#EditActivity.Mission#', '#EditActivity.MandateNo#','')" value="...">
				</td>
				<td class="hide" id="processunit"></td>
				</tr>
				</table>
				<input type="hidden" name="orgunit"      id="orgunit"      value="#EditActivity.OrgUnit#">
				<input type="hidden" name="orgunitcode"  id="orgunitcode"  value="#EditActivity.OrgUnitCode#">
			    <input type="hidden" name="mission"      id="mission"      value="#EditActivity.Mission#">
				<input type="hidden" name="orgunitclass" id="orgunitclass" value="" class="disabled" size="20" maxlength="20" readonly> 
			<cfelse>
				#EditActivity.OrgUnitName#
			</cfif>	
		
		</td>
	</tr>	
		
	<!--- remove possible empty entries --->
	
	<cfquery name="LocationList" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   N.Code,N.Name,L.LocationCode,L.Description,N.Continent,LocationDefault
		FROM     Ref_PayrollLocation L, 
		         System.dbo.Ref_Nation N,
				 Ref_PayrollLocationMission M
		WHERE    L.LocationCountry = N.Code
		AND      M.LocationCode = L.LocationCode
		AND      M.Mission = '#EditActivity.Mission#'	
		AND      M.BudgetPreparation = 1	
		AND      N.Code != 'UUU'			
		ORDER BY N.Name,L.LocationCode,L.Description
	</cfquery>	
	
	<cfif LocationList.recordcount eq "0">
	
		<cfquery name="LocationList" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   Code,Name,LocationCode,L.Description,Continent,'' as LocationDefault
			FROM     Ref_PayrollLocation L, System.dbo.Ref_Nation N
			WHERE    L.LocationCountry = N.Code		
			AND      N.Code != 'UUU'			
			ORDER BY Name, LocationCode,Description
		</cfquery>		
		
	</cfif>
	
	<cfquery name="Locations" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *	        
	FROM     ProgramActivityLocation
	WHERE    ProgramCode    = '#URL.ProgramCode#'
	AND      ActivityPeriod = '#URL.Period#'
	AND      ActivityID     = '#URL.ActivityID#'  
	</cfquery>
	
	<cfset locs = valueList(Locations.LocationCode)>
	
	<!--- Field: Location--->
	
	<tr>
		<TD valign="top" style="padding-top:3px" class="labelmedium"><cf_tl id="Location">:</TD>
	    <TD colspan="3" class="labelmedium">
				
		     <table width="100%">
			 
			 	<tr class="labelmedium">
				
				<cfif ProgramAccess eq "ALL" or completed eq "0">
				<td style="padding-left:3px;width:20px;padding-top:3px;padding-right:3px"><cf_img icon="expand" toggle="yes" onclick="locationtoggle()"></td>
				</cfif>
				
				<td id="locationselected" style="padding-top:2px">
				
				<cfset row = 0>
				
				<cfloop index="loc" list="#locs#">
				
					<cfset row = row+1>
														
					<cfquery name="getName" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   Code,Name,
						         LocationCode,
								 L.Description,Continent,'' as LocationDefault
						FROM     Ref_PayrollLocation L, System.dbo.Ref_Nation N
						WHERE    L.LocationCountry = N.Code		
						AND      LocationCode = '#loc#'
					</cfquery>		
		
					<cfif row gt "1">;&nbsp;</cfif>#getName.Name# #getName.Description# 
				
				
				</cfloop>
				
				
				</td>
				<td></td>
				
				</tr>
				
				<cfif ProgramAccess eq "ALL" or completed eq "0">
				
					<tr class="hide" id="selectlocation">
					
					    <td colspan="3" style="padding-top:6px;padding-left:10px">
					
						<table width="94%" cellspacing="0" cellpadding="0">
						
						  <cf_divscroll>	
						  
						  <cfset cnt   = 0>
						  <cfset prior = "">
						  
						  <cfloop query="LocationList">
						  					   
		                       <cfset cnt = cnt+1>
							   
							   <cfif cnt eq "1">					  
							   	<tr class="linedotted">
							   </cfif>	
							   
								   <td style="padding-left:1px;padding-right:5px">
								   <cfif find(locationcode,locs)>	
								      	<cfset cl = "0080C0">			   
									   <input type="checkbox" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#session.root#/ProgramREM/Application/Program/ActivityProject/setLocation.cfm','locationselected','','','POST','activityentryform')"
									    name="LocationCode" value="#LocationCode#" checked>
								   <cfelse>
								       <cfset cl = "black">						   	   						   
									   <input type="checkbox" onclick="_cf_loadingtexthtml='';ColdFusion.navigate('#session.root#/ProgramREM/Application/Program/ActivityProject/setLocation.cfm','locationselected','','','POST','activityentryform')"  name="LocationCode" value="#LocationCode#">
								   </cfif>
								   </td>				   
								   <td class="labelit" style="height:15px;padding-right:6px"><cfif prior neq name><b>#Name#</b>,</cfif> <font color="#cl#">#Description#</font></td>
								   
							   <cfif cnt eq "4">
								   <cfset cnt = "0">
								   </tr>
							   </cfif>
							   
							   <cfset prior = name>
						   
						  </cfloop> 
						  
						  </cf_divscroll>
						  
					    </table>
					
					   </td>
					
				 </tr>
				
			   </cfif>	
			 
			 </table>
				
		</TD>
	
	</TR>
			
	<!--- classification --->
		
	<cfquery name="check" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT Code 
		FROM   Ref_ActivityClassMission 
		WHERE   Mission = '#EditActivity.Mission#'
	</cfquery>	
	
	<cfif check.recordcount gte "1">
			
	<TR>
	<td height="24" valign="top" style="padding-top:4px" class="labelmedium">
		<cf_tl id="Classification">:
	</td>
	<td height="24" colspan="3">
		<cfinclude template="../ActivityProgram/ActivityEntryClass.cfm"> 
	</td>
	</TR>
	
	</cfif>
	
	 <tr>
			
	   <td width="128" class="labelmedium"><cf_tl id="External Reference">:</TD>
	   
	   <td colspan="3" class="labelmedium">
	 
       <cfif EditActivity.Reference eq "TMP">
	      <cfset t = "">
	   <cfelse>
	      <cfset t = EditActivity.Reference>
	   </cfif>
	
	 <cfif ProgramAccess eq "ALL" or completed eq "0">
			<cfinput style="border:1px solid silver;padding-left:5px;" class="regularxl enterastab" name="Reference" value="#t#" type="text" size="20" maxlength="20" required="no">
		<cfelse>
		    <cfif EditActivity.Reference eq "">
			N/A
			<cfelse>
			#EditActivity.Reference#
			</cfif>
		</cfif>
	   </td>
	   
	 </tr>	
	 
	<cfif AdminAccess eq "ALL" or AdminAccess eq "EDIT">
	   
	<tr>
	   <TD class="labelmedium"><cf_tl id="Relative Weight">:</TD>
       <TD class="labelmedium">	   
	  
		  <cfif completed eq "0">
		  
			   <cfif EditActivity.ActivityWeight eq "0"><cfset w="1"><cfelse><cfset w = "#EditActivity.ActivityWeight#"></cfif>
			   
			    <cfinput type="Text" name="ActivityWeight" class="regularxl enterastab" value="#w#" 
				range="1,10" message="#msg4#" 
				validate="integer" required="No" style="border:1px solid silver;padding-left:5px;width:25px;text-align:center" size="3" maxlength="3"> <font size="2">[range from 1 - 10]</font>
	
		   <cfelse>
		   
			   #EditActivity.ActivityWeight#
			   
		   </cfif>
		   
		   
	   </TD>
	 	   
	</TR>
	
	<cfelse>
	
		<input type="hidden" name="ActivityWeight" id="ActivityWeight" value="#EditActivity.ActivityWeight#">
						
	</cfif>
			
</cfoutput>