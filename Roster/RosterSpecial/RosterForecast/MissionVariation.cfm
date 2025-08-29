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
<cf_screentop height="100%" scroll="Yes" html="No">

<cfajaximport>

<cfparam name="URL.BucketId" default="{9590832E-B28D-4DD4-8734-03BC5C30C095}">
<cfparam name="URL.Owner"    default="SysAdmin">
<cfparam name="URL.Rule"     default="101">

<cfquery name="Mission" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
	SELECT * FROM Ref_Mission
	WHERE MissionOwner = '#url.owner#'		
</cfquery>		

<cfset FileNo = round(Rand()*100)>
  
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Forecast#FileNo#">	
 
<cfquery name="Table" 
	datasource="appsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT   Source, Mission, TransactionDate, sum(TransactionQuantity) as TransactionQuantity
		INTO     userquery.dbo.#SESSION.acc#Forecast#FileNo#
		FROM     FunctionBucketForecast
		WHERE    BucketId        = '#url.bucketid#'				
		AND      RuleCode        = '#url.rule#'				
		GROUP BY Source, Mission, TransactionDate			
</cfquery>	

<table width="100%" cellspacing="0" cellpadding="0" align="center">

<tr bgcolor="ffffcf"><td height="20"><font color="808080">&nbsp;Define estimated variations per mission for the coming period.</td>
                     <td align="right"><i>Attention : Updated values are immediately saved!</td>
</tr>
<tr><td height="1" colspan="2" bgcolor="silver"></td></tr>
<tr><td height="1" colspan="2" bgcolor="f6f6f6">&nbsp;Bucket Name</td></tr>	
<tr><td height="1" colspan="2" bgcolor="silver"></td></tr>	
<tr><td height="4" colspan="2" id="result"></td></tr>

<tr><td align="center" colspan="2">

	<table width="97%" border="1" bordercolor="silver" cellspacing="0" cellpadding="0" align="center" class="formpadding">
					
		<!--- header --->
		<tr>
		
		<td class="top4n"><cf_space spaces="40" label="Mission"></td>
		
		<cfset date = CreateDateTime(year(now()), month(now()), "1","0","0","0")>
				
		<cfloop index="mth" from="1" to="12">
				
			<cfset ft = dateAdd("m", mth, date)> 
				
			<cfoutput>	
				<td align="center" class="top4n">		
				<cf_space spaces="17" label="#MonthAsString(month(ft))#">					
				</td>	
			</cfoutput>	
			
		</cfloop>	
		
		</tr>
		
		<cfoutput query="Mission">
		
		<tr>
		<td bgcolor="f9f9f9">&nbsp;#Mission#</td>
					
			<cfloop index="mth" from="1" to="12">
			
				<cfset ft = dateAdd("m", mth, date)>
					
				<td align="center" id="cell_#currentrow#_#mth#">	
				
				<table cellspacing="0" cellpadding="0" class="formpadding">
				
					<cfquery name="Value" 
					datasource="appsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#"> 
						SELECT   *
						FROM     #SESSION.acc#Forecast#FileNo#
						WHERE    Mission         = '#mission#'								
						AND      Source          != 'Manual'
						AND      TransactionDate = #ft#								
					</cfquery>	
														
					<td>
					
					<input type="text"
			       value="#Value.TransactionQuantity#"
			       readonly
			       class="amount"
			       style="width: 30; background-color: AFEEEE;">	
					
					</td>
				
					<cfquery name="Value" 
					datasource="appsQuery" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#"> 
						SELECT   *
						FROM     #SESSION.acc#Forecast#FileNo#
						WHERE    Mission         = '#mission#'								
						AND      Source          = 'Manual'
						AND      TransactionDate = #ft#								
					</cfquery>	
														
					<td>
					
						<cfset dte = dateformat(ft,CLIENT.DateFormatShow)>
					
						<input type="text" 
						   style="width:30" 
						   class="amount" 
						   onchange="ColdFusion.navigate('MissionVariationSubmit.cfm?bucketid=#bucketid#&mission=#mission#&rule=#rule#&date=#dte#&quantity='+this.value,'result')"
						   name="Var_#year(ft)#_#month(ft)#" 
						   value="#Value.TransactionQuantity#">	
					   
					</td>
										
					</tr>
					
					</table>	   			
				</td>	
							
			</cfloop>			
		
		</tr>
		
		</cfoutput>	
	
	</table>

</td></tr>
</table>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Forecast#FileNo#">	