<cfparam name="url.showPrintButton" default="1">

<!--- retrieve data --->
<cfinclude template="EntityConfigPrint\ActionClassPrintPrepare.cfm">

<cf_screentop html="no" jquery="yes" scroll="yes" title="#SESSION.welcome# : ENTITY: #Entity.EntityDescription# [#Entity.EntityCode#] / WF: #Class.EntityClassName# [#URL.EntityClass#]">

<cfoutput>

<cfif url.showPrintButton eq 1>
	<table width="100%" class="clsNoPrint">
		<tr class="noprint">
			<td align="left">
				&nbsp;&nbsp;
				<a href="javascript:Prosis.webPrint.print('##printTitle','##printContent', true, null);" style="color:##808080; font-size:15px;">
					<img 
					src="#SESSION.root#/images/print.gif" 
					title="" 
					align="absmiddle" 
					border="0">
					<cf_tl id="Print">
				</a>
			</td>
		</tr>
		<tr class="noprint"><td align="center"><hr style="color: Silver;"></td></tr>
	</table>
</cfif>

<table width="100%" align="center">

	<tr>
		<td id="printTitle" style="width:100%;">
			<table width="100%" align="center" cellspacing="0" cellpadding="0">
				<tr>
					<td align="left">ENTITY: #Entity.EntityDescription# [#Entity.EntityCode#]</td>		
					<td align="Right">WF: #Class.EntityClassName# [#URL.EntityClass#]</td>
				</tr>
				<tr><td colspan="2" class="line"></td></tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td id="printContent" style="width:100%;">
			<cfif URL.PrintWF eq "true">
				<cfinclude template="EntityFlowPrint\FlowViewPrint.cfm">
				<table style="page-break-after: always;"><tr><td></td></tr></table>	
			</cfif>
			
			<cfif URL.PrintDocs eq "true" or URL.PrintConfig eq "true" >
				<cfinclude template="EntityConfigPrint\ActionStepPrint.cfm"> 
			</cfif>
		</td>
	</tr>

</table>


</cfoutput>
