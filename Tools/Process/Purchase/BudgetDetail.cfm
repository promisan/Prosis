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

<cfparam name="Attributes.Mode"            default="select">
<cfparam name="Attributes.Mission"         default="">
<cfparam name="Attributes.Option"          default="Allotment">
<cfparam name="Attributes.BudgetMode"      default="Allotment">
<cfparam name="Attributes.Fund"            default="">
<cfparam name="Attributes.ProgramNo"       default="">
<cfparam name="Attributes.ProgramSubNo"    default="">
<cfparam name="Attributes.ProgramProject"  default="">
<cfparam name="Attributes.ProgramAction"   default="">
<cfparam name="Attributes.ExecutiveOffice" default="">
<cfparam name="Attributes.LocationCode"    default="">
<cfparam name="Attributes.ObjectCode"      default="">
<cfparam name="Attributes.ProgramCode"     default="">
<cfparam name="Attributes.Row"             default="">


<cfparam name="url.id" default="">

<cfset row             = attributes.row>
<cfset fund            = attributes.fund>
<cfset mode            = attributes.mode>
<cfset BudgetMode      = attributes.BudgetMode>
<cfset Option          = attributes.Option>
<cfset Mission         = attributes.Mission>
<cfset ProgramCode     = attributes.ProgramCode>
<cfset ProgramNo       = attributes.ProgramNo>
<cfset ProgramSubNo    = attributes.ProgramSubNo>
<cfset ProgramProject  = attributes.ProgramProject>
<cfset ProgramAction   = attributes.ProgramAction>
<cfset ExecutiveOffice = attributes.ExecutiveOffice>
<cfset LocationCode    = attributes.LocationCode>
<cfset ObjectCode      = attributes.ObjectCode>

<cfoutput>
<cfsavecontent variable="Program">
AND      ProgramCode IN 
			(SELECT ActivityCode 
             FROM Program.dbo.BudgetActivity 
			 WHERE 1=1			 
			 <cfif ProgramNo neq "">
			 AND ProgramNo = '#ProgramNo#' 
			 </cfif>
			 <cfif ProgramSubNo neq "">
			 AND ProgramSubNo = '#ProgramSubNo#'
			 </cfif>
			 <cfif ProgramProject neq "">
			 AND ProgramProject = '#ProgramProject#'
			 </cfif>
			 <cfif ProgramCode neq "">
			 AND ActivityCode = '#ProgramCode#'
			 </cfif>
			 <cfif ProgramAction neq "">
			 AND ProgramAction = '#ProgramAction#'
			 </cfif>
			 <cfif ExecutiveOffice neq "">
			 AND ExecutiveOffice = '#ExecutiveOffice#' 
			 </cfif>
			 <cfif LocationCode neq "">
			 AND LocationCode = '#LocationCode#'
			 </cfif>										 
			 )		
</cfsavecontent>
</cfoutput>

<cfoutput>
		
		<cfif ProgramCode neq "">
		
		<td align="right" <cfif objectcode eq "">id="all_#programcode#"</cfif>>	
		
		<cfelseif LocationCode neq "">
		
		<td align="right" <cfif objectcode eq "">id="all_#ExecutiveOffice#_#LocationCode#"</cfif>>	
		
		<cfelseif ExecutiveOffice neq "">
		
		<td align="right" <cfif objectcode eq "">id="all_#ExecutiveOffice#"</cfif>>	
		
		<cfelse>
		
		<td align="right">	
		
		</cfif>		
		
		<!--- define reservations --->
		<cfquery name="Reservation" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   SUM(ReservationAmount) as ReservationAmount
		FROM     dbo.#SESSION.acc#Requisition
		WHERE     1=1
				<cfif option neq "Budget">
					<cfif Fund eq "">
					AND       Fund is NULL
					<cfelse>
					AND       Fund = '#Fund#'
					</cfif>
				</cfif>
				#preserveSingleQuotes(Program)#			
				<cfif ObjectCode neq "">
				AND       ObjectCode = '#ObjectCode#' 
				</cfif>				   
		</cfquery>		
		
		<!--- define obligations --->
		<cfquery name="Obligation" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   SUM(ObligationAmount) as ObligationAmount
		FROM     dbo.#SESSION.acc#Obligation
		WHERE     1=1
				<cfif option neq "Budget">
					<cfif Fund eq "">
					AND       Fund is NULL
					<cfelse>
					AND       Fund = '#Fund#'
					</cfif>
				</cfif>
				#preserveSingleQuotes(Program)#		
				<cfif ObjectCode neq "">
				AND       ObjectCode = '#ObjectCode#'
				</cfif>						   
		</cfquery>		
		
		<cfif Reservation.ReservationAmount eq "">
		  <cfset res = 0>
		<cfelse>
		  <cfset res =  Reservation.ReservationAmount>
		</cfif>
		
		<cfif Obligation.ObligationAmount eq "">
		  <cfset obl = 0>
		<cfelse>
		  <cfset obl =  Obligation.ObligationAmount>
		</cfif>
				
		<cfif attributes.budgetmode eq "Allotment" or 
		(attributes.budgetmode eq "Budget" and attributes.ObjectCode eq "" and attributes.option eq "Budget")>
		
			<cfquery name="Total" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    SUM(Total) AS Total
				FROM      dbo.#SESSION.acc#Allotment
				WHERE     1=1
				<cfif option neq "Budget">
					<cfif Fund eq "">
					AND       Fund is NULL
					<cfelse>
					AND       Fund = '#Fund#'
					</cfif>
				</cfif>
				#preserveSingleQuotes(Program)#		
				<cfif ObjectCode neq "">
				AND       ObjectCode = '#ObjectCode#'
				</cfif>							 	
		    </cfquery>	
			
			<cfif Obl+res gt total.total>
			<font color="FF0000"><b>	
			</cfif>
			#numberformat(Total.total,"_,_")#		
			
		</cfif>		
			
		</td>
	
		
		<cfif Reservation.ReservationAmount neq "" and ObjectCode neq "">	
		    <td align="right" width="100" onclick="bmore('add','#ProgramCode#_#Row#','#Fund#','#URL.ID#','#Period#','#ProgramCode#','#ObjectCode#','show','list','#Mission#')" style="cursor: pointer;">			
			#numberformat(Reservation.ReservationAmount,"_,_")#
		<cfelse>
		    <td align="right" width="100">			
		    #numberformat(Reservation.ReservationAmount,"_,_")#
			
		</cfif>	
	
	</td>
		
				
		<cfif Obligation.ObligationAmount neq "" and ObjectCode neq "">		   
		   <td align="right" width="100" onclick="bmore('add','#ProgramCode#_#Row#','#Fund#','#URL.ID#','#Period#','#ProgramCode#','#ObjectCode#','show','list','#Mission#')" style="cursor: pointer;">		   
			#numberformat(Obligation.ObligationAmount,"_,_")#			
		<cfelse>
		    <td align="right" width="100">
			#numberformat(Obligation.ObligationAmount,"_,_")#
		</cfif>				
	
	</td>
	
	<td align="right" width="100">
			
		#numberformat(Obl+res,"_,_")#	
	
	</td>
	
		<cfif budgetmode eq "Allotment">
			
			<!--- define obligations --->
			<cfquery name="Invoice" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   SUM(InvoiceAmount) as InvoiceAmount
			FROM     dbo.#SESSION.acc#Invoice
			WHERE     1=1
					<cfif option neq "Budget">
						<cfif Fund eq "">
						AND       Fund is NULL
						<cfelse>
						AND       Fund = '#Fund#'
						</cfif>
				    </cfif>
					#preserveSingleQuotes(Program)#		
					<cfif ObjectCode neq "">
					AND       ObjectCode = '#ObjectCode#'
					</cfif>					   
			</cfquery>			
			
			<cfif Invoice.InvoiceAmount neq "" and ObjectCode neq "">
			 <td align="right" width="100" onclick="imore('inv','#ProgramCode#_#CurrentRow#','#Edition.Fund#','#URL.ID#','#URL.Period#','#URL.ProgramCode#','#Code#','show','list','#Mission#')" style="cursor: pointer;">		   
				#numberformat(Invoice.InvoiceAmount,"_,_")#
			<cfelse>
			 <td align="right" width="100">
				#numberformat(Invoice.InvoiceAmount,"_,_")#
			</cfif>
			</td>
			
		<cfelse>
		
		<td></td>	
			
		</cfif>	
	
</cfoutput>		