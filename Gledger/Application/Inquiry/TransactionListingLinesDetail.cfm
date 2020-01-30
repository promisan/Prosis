<cfparam name="url.description" default="">
<cfparam name="headerno" default="">
<cfparam name="currrow" default="">

<cfoutput>

	<tr class="navigation_row line labelmedium">
	<td style="height:17px" style="padding-left:3px"><cfif currentrow eq "1"><cf_space spaces="4"></cfif><cfif currrow eq "">#currentrow#<cfelse>#currrow#</cfif>.</td>
	<TD style="min-width:120px" class="navigation_action" onclick="ShowTransaction('#Journal#','#JournalSerialNo#')">
		<cfif currentrow eq "1"><cf_space spaces="29"></cfif>
		<a href="javascript:ShowTransaction('#Journal#','#JournalSerialNo#')"><font color="0080C0">
		<cfif JournalTransactionNo eq "">#JournalSerialNo#<cfelse>#JournalTransactionNo#</cfif>	
	</a>
	</TD>
  	<TD style="padding-left:4px">#GLAccount#</TD>
	<TD style="padding-left:4px"><a href="javascript:showledger('#mission#','','#AccountPeriod#','#GLAccount#')"><font color="0080C0">#GLAccountName#</a></font></TD>	
	
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
    <td style="border-left:1px solid silver" align="right"><cfif AmountDebit neq "0">#NumberFormat(AmountDebit,'_,____.__')#</cfif>&nbsp;</td>	
	<td style="border-left:1px solid silver" align="right"><cfif AmountCredit neq "0">#NumberFormat(AmountCredit,'__,___.__')#</cfif>&nbsp;</td>	
    <td style="border-left:1px solid silver" align="right"><cfif AmountBaseDebit neq "0">#NumberFormat(AmountBaseDebit,'_,____.__')#</cfif>&nbsp;</td>	
	<td style="border-left:1px solid silver;border-right:1px solid silver" align="right"><cfif AmountBaseCredit neq "0">#NumberFormat(AmountBaseCredit,'_,____.__')#</cfif>&nbsp;</td>	
		
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