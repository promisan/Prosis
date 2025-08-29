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
<cfparam name="url.description" default="">
<cfparam name="headerno" default="">
<cfparam name="currrow" default="">

<cfoutput>

	<tr class="navigation_row line labelmedium" style="height:20px">
	<td style="height:17px;padding-left:3px"><cfif currentrow eq "1"><cf_space spaces="4"></cfif><cfif currrow eq "">#currentrow#<cfelse>#currrow#</cfif>.</td>
	<TD style="min-width:120px" class="navigation_action" onclick="ShowTransaction('#Journal#','#JournalSerialNo#')">
		<cfif currentrow eq "1"><cf_space spaces="29"></cfif>
		<a href="javascript:ShowTransaction('#Journal#','#JournalSerialNo#')">
		<cfif JournalTransactionNo eq "">#JournalSerialNo#<cfelse>#JournalTransactionNo#</cfif>	
	</a>
	</TD>
  	<TD style="padding-left:4px">#GLAccount#</TD>
	<TD style="min-width:190px;padding-left:4px"><a href="javascript:showledger('#mission#','','#AccountPeriod#','#GLAccount#')">#GLAccountName#</a></TD>	
	
	<TD>	
	
	<cfif url.description eq "">	
		
		#Memo# #Reference# #ReferenceName# <cfif referenceNo neq "">(#ReferenceNo#)<cfelse></cfif>	
			
	<cfelse>	
	
		#replaceNoCase(Memo,url.description,'<u><font color="FF0000">#url.description#</font></u>', 'ALL')# 
		<cfif Reference neq "Contra-account">
		#replaceNoCase(reference,url.description,'<u><font color="FF0000">#url.description#</font></u>', 'ALL')# 
		</cfif>	
		#replaceNoCase(ReferenceName,url.description,'<u><font color="FF0000">#url.description#</font></u>', 'ALL')# 
		<cfif referenceNo neq "">
		(#replaceNoCase(ReferenceNo,url.description,'<u><font color="FF0000">#url.description#</font></u>', 'ALL')#) 
		</cfif>
		
	</cfif>	
	
	</TD>
	
	<TD>#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</TD>
    <TD>#Currency#</TD>
    <td style="border-left:1px solid silver" align="right"><cfif AmountDebit neq "0">#NumberFormat(AmountDebit,',.__')#</cfif>&nbsp;</td>	
	<td style="border-left:1px solid silver" align="right"><cfif AmountCredit neq "0">#NumberFormat(AmountCredit,',.__')#</cfif>&nbsp;</td>	
    <td style="border-left:1px solid silver" align="right"><cfif AmountBaseDebit neq "0">#NumberFormat(AmountBaseDebit,',.__')#</cfif>&nbsp;</td>	
	<td style="border-left:1px solid silver;border-right:1px solid silver" align="right"><cfif AmountBaseCredit neq "0">#NumberFormat(AmountBaseCredit,',.__')#</cfif>&nbsp;</td>	
		
	<cfif AmountBaseDebit is not "">	
    	<cfset AmtD  = AmtD  + AmountBaseDebit>
		<cfset AmtDT = AmtDT + AmountBaseDebit>
	</cfif>	
	<cfif AmountBaseCredit is not "">	
        <cfset AmtC = AmtC   + AmountBaseCredit>	
		<cfset AmtCT = AmtCT + AmountBaseCredit>		
    </cfif>
	</tr>
		
</cfoutput>			