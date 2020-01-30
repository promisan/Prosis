
<!--- set overtime entry --->

<cfparam name="url.overtimeid" default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.accessmode" default="edit">

<cfif url.payment eq "9">

	<cfquery name="Get" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT 	*
		    FROM   	PersonOvertime
			WHERE  	OvertimeId = '#URL.overtimeid#'
			AND 	PersonNo = '#url.PersonNo#'			
		</cfquery>		
	
	<table>
		
		 <tr style="height:20px"><td>
		     
			 <cfoutput>
			  
		     <cfif url.accessmode eq "view">
			 
			 	#Get.OvertimeHours# 
			 
			 <cfelse>
			   
				<select name="OvertimeHours" id="OvertimeHours" class="regularxl" style="border:0px;width:60px;text-align:center">
				<cfloop index="hr" from="0" to="200">
				<option value="#hr#" <cfif Get.OvertimeHours eq hr>selected</cfif>>#hr#</option>
				</cfloop>
				</select>
				
			  </cfif>	
			  
			  </cfoutput>
			  
			</td>
			<td style="padding-left:4px;padding-right:4px">:</td>
			<td>
			
				<cfoutput>
									 
				    <cfif url.accessmode eq "view">
					 
					 	#Get.OvertimeMinutes# 
					 
					<cfelse>
					 
						<select name="OvertimeMinut" id="OvertimeMinut" class="regularxl" style="border:0px;text-align:center">
						<cfloop index="min" from="0" to="3">	
						<option value="#min*15#" <cfif Get.OvertimeMinutes eq min*15>selected</cfif>>#min*15#</option>
						</cfloop>
						</select>
						
					</cfif>
					
				</cfoutput>
			
			</td>			
			
			</tr>
			
	</table>	

<cfelse>
			
		<cfquery name="Trigger" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   * 
			    FROM     Ref_PayrollTrigger
				WHERE    TriggerGroup = 'Overtime'
				<cfif url.payment eq "0">
				AND      SalaryTrigger != 'NightDiff' 
				</cfif>
				ORDER BY TriggerSort
		</cfquery>	

        <table width="500">
		
			<tr class="line labelmedium">
			    <td><cf_tl id="Type"></td>
				<td><cf_tl id="Hrs"></td>
				<td><cf_tl id="Min"></td>
				<td style="padding-left:4px"><cf_tl id="Memo"></td>
			</tr>
			
			<cfoutput query="Trigger">
			
				<cfquery name="GetDetail" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT 	*
				    FROM   	PersonOvertimeDetail
					WHERE  	OvertimeId = '#URL.overtimeid#'
					AND 	PersonNo = '#url.PersonNo#'
					AND 	SalaryTrigger = '#SalaryTrigger#'
				</cfquery>
		
				<tr class="labelmedium line" style="height:20px">
				
				<td style="min-width:150;padding-right:10px">#Description#:</td>
				<td style="padding-right:4px;border-left:1px solid silver;min-width:50px" align="right">
				
					 <cfif url.accessmode eq "view">
			 
			 			#GetDetail.OvertimeHours# 
			 
					 <cfelse>
			 
					<select class="regularxl clsDetailHours" onchange="setInitDetailValue()" name="#SalaryTrigger#_hour" style="border:0px;width:50px">
						<cfloop index="hr1" from="0" to="200">
							<option value="#hr1#" <cfif GetDetail.OvertimeHours eq hr1>selected</cfif>>#hr1#</option>
						</cfloop>
					</select>
					
					</cfif>
					
				</td>
				
				<td style="padding-right:4px;border-left:1px solid silver;min-width:50px" align="right">
				
					 <cfif url.accessmode eq "view">
			 
					 	#GetDetail.OvertimeMinutes# 
			 
					 <cfelse>
				
					<select class="regularxl clsDetailMinutes" onchange="setInitDetailValue()" name="#SalaryTrigger#_minu" style="border:0px;width:55px">
						<cfloop index="min1" from="0" to="3">						
							<option value="#min1*15#" <cfif GetDetail.OvertimeMinutes eq (min1*15)>selected</cfif>>#min1*15#</option>
						</cfloop>
					</select>
					
					</cfif>
					
				</td>
				
				<td width="70%" style="padding-left:5px;border-left:1px solid silver;border-right:1px solid silver">
					 <cfif url.accessmode eq "view">
			 
					 	#GetDetail.Memo# 
			 
					 <cfelse>
					     <input type="text"
						  name="#SalaryTrigger#_memo" value="#GetDetail.Memo#" size="60" maxlength="100" 
						  class="regularxl clsDetailMinutes enterastab" style="border:0px;width:99%">					
						  
					 </cfif>	  
				</td>	
				
				</tr>	
									
			</cfoutput>
			
			<cfquery name="Get" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT 	*
				    FROM   	PersonOvertime
					WHERE  	OvertimeId = '#URL.overtimeid#'
					AND 	PersonNo = '#url.PersonNo#'					
				</cfquery>
			
			<tr style="height:32px" class="line labelmedium">
				  <td><cf_tl id="Total"></td>
				  <td id="total" class="labellarge" style="font-size:18px;padding-left:6px">
				  <cfif get.recordcount gte "1">
					  <cfset url.minutes = (get.overtimehours*60)+get.overtimeminutes>				 
					  <cfinclude template="setTotal.cfm">
				  </cfif>			  
				  </td>
				  <td></td>
				  <td></td>
			</tr>
		</table>

</cfif>