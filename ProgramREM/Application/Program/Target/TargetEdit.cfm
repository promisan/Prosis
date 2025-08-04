<!--
    Copyright © 2025 Promisan

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

<cfparam name="url.category" default="">   

<cfquery name="get" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
   	  SELECT	*
	  FROM  	ProgramTarget
	  WHERE 	ProgramCode  = '#url.ProgramCode#'
	  AND   	Period = '#url.period#'
	  <cfif trim(url.targetid) neq "">
	  AND		TargetId = '#url.targetid#'
	  <cfelse>
	  AND		1=0
	  </cfif>
</cfquery>

<table class="hide"><tr><td id="targetsubmit"></td></tr></table>

<cfset ht = "100">

<cfoutput>

	<cfform name="frmTarget" onsubmit="return false">
	
		<table width="99%" align="center">
			
			<tr>
				<td>
				   <table><tr>
				   
				   <td class="labelmedium" style="padding-left:10px;padding-right:10px;"><cf_tl id="Reference">:</td>
						<td>
							<cfinput 
								type="Text" 
								name="TargetReference" 
								id="TargetReference" 
								maxlength="20" 
								size="15" 
								class="regularxl" 
								required="yes"
								value="#get.TargetReference#"
								message="Please, enter a valid reference">
						</td>
												
						<td style="padding-left:30px; padding-right:10px;" class="labelmedium" width="15%"><cf_tl id="Due"></td>
						<td>
						
							<cfset vDueDate = "">
							<cfif get.TargetDueDate neq "">
								<cfset vDueDate = dateFormat(get.TargetDueDate, client.dateFormatShow)>
							</cfif>
							
							<cf_intelliCalendarDate9
								FieldName="TargetDueDate"
								Default="#vDueDate#"
								class="regularxl"
								AllowBlank="True">
								
						</td>
						
						<td class="labelmedium" style="padding-left:30px;padding-right:10px;"><cf_tl id="Sort"></td>
					    <td>
						
							<cfinput type="Text" 
								name="ListingOrder" 
								id="ListingOrder" 
								maxlength="2" 
								size="2" 
								class="regularxl" 
								validate="integer" 
								required="no"
								value="#get.ListingOrder#"
								message="Please, enter a valid numeric sort" 
								style="text-align:center;">							
								
						</td>			
							
						</tr>
					</table>
				</td>
			</tr>		
						
			<tr class="line"><td class="labellarge" style="height:43px;padding-left:10px;font-size:20px"><cf_tl id="Description">:</td></tr>			
			<tr>
				<td style="padding-left:15px;padding-right:20px">
				
				      <cf_textarea name="TargetDescription"
						   id             = "TargetDescription"                                           
						   height         = "#ht#"
						   toolbar        = "mini"
						   resize         = "yes"
						   color          = "ffffff">#get.TargetDescription#</cf_textarea>
						
				</td>
			</tr>	
			
			<tr class="line"><td class="labellarge" style="height:43px;padding-left:10px;font-size:20px"><cf_tl id="BaseLine">:</td></tr>
			<tr>
				<td style="padding-left:15px;padding-right:20px">
				<cf_textarea name="TargetIndicator"
						   id             = "TargetIndicator"                                           
						   height         = "#ht#"
						   toolbar        = "mini"
						   resize         = "yes"
						   color          = "ffffff">#get.TargetIndicator#</cf_textarea>
				

				</td>
			</tr>						
					
			<tr class="line"><td class="labellarge" style="height:43px;padding-left:10px;font-size:20px"><cf_tl id="Target">:</td></tr>			
			<tr>
				<td style="padding-left:15px;padding-right:20px">
				   <cf_textarea name="Outcome"
						   id             = "Outcome"                                           
						   height         = "#ht#"
						   toolbar        = "mini"
						   resize         = "yes"
						   color          = "ffffff">#get.Outcome#</cf_textarea>
						   

				</td>
			</tr>						
					
			<tr class="line"><td class="labellarge" style="height:43px;padding-left:10px;font-size:20px"><cf_tl id="Outcome Verification">:</td></tr>
			<tr>
				<td style="padding-left:15px;padding-right:20px">
				<cf_textarea name="OutcomeVerification"
						   id             = "OutcomeVerification"                                           
						   height         = "#ht#"
						   toolbar        = "mini"
						   resize         = "yes"
						   color          = "ffffff">#get.OutcomeVerification#</cf_textarea>

				</td>
			</tr>							
			<tr class="line"><td class="labellarge" style="height:43px;padding-left:10px;font-size:20px"><cf_tl id="External Factor">:</td></tr>
			<tr>
				<td style="padding-left:15px;padding-right:20px">
				
				<cf_textarea name="ExternalFactor"
						   id             = "ExternalFactor"                                           
						   height         = "#ht#"
						   toolbar        = "mini"
						   resize         = "yes"
						   color          = "ffffff">#get.ExternalFactor#</cf_textarea>
				 

				</td>
			</tr>
						
			<tr><td class="line"></td></tr>
									
			<tr>
				<td align="center">
				    <table>
					<tr>
						<td align="center">
						    <CFIF url.category eq "">
							<cf_tl id="Cancel" var="1">
							<input type="button" class="button10g" style="width:150px" value="#lt_text#" onclick="Prosis.busy('yes'); parent.right.document.getElementById('targetrefresh').click();">													
							</cfif>
						</td>
						<td style="padding-left:1px">					
							<cf_tl id="Save" var="1">
							<input type="button" class="button10g" style="width:150px" value="#lt_text#" onclick="updateTextArea();saveTarget('#url.programcode#','#url.period#','#url.targetid#','#url.category#','#url.programaccess#')">
						</td>
					</tr>
					</table>
				</td>
			</tr>
			
			<tr><td style="height:2px"></td></tr>
			
		</table>
	</cfform>

</cfoutput>

<cfset AjaxOnLoad("initTextArea")>
<cfset AjaxOnLoad("doCalendar")>

<script>
	Prosis.busy('no');
</script>