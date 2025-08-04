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

<cf_menuscript>
<cfajaximport tags="cfdiv">

<cf_tl id="Do you want to remove this account ?" var="vPurgeAccMsg">

<cfoutput>

<script  language="javascript">
	
	function journal() {
		ptoken.navigate('JournalEdit.cfm?ID1=#URL.ID1#','contentbox1');
	}	
	
	function journal_action() {
		ptoken.navigate('JournalActionEdit.cfm?ID1=#URL.ID1#','contentbox2');
	}
	
	function costcenter() {
		ptoken.navigate('JournalCostCenter.cfm?ID1=#URL.ID1#','contentbox2');
	}
	
	function glaccount() {
		ptoken.navigate('JournalAccount/JournalAccount.cfm?ID1=#URL.ID1#','contentbox2');
	}
			
	function editJournalAccount(j,a) {
		ProsisUI.createWindow('journalaccount', 'Add account', '',{x:60,y:60,height:330,width:660,modal:true,resizable:false,center:true});			
		ptoken.navigate('JournalAccount/JournalAccountEdit.cfm?journal='+j+'&account='+a,'journalaccount');
	}
	
	function applyaccount(acc) {
   		ptoken.navigate('#session.root#/Gledger/Maintenance/LedgerSchema/Journal/setAccount.cfm?account='+acc,'process')
	}  
	
	function accountvalidate() {
		document.frmJournalAccount.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
	 		ptoken.navigate('JournalAccount/JournalAccountSubmit.cfm?journal=#URL.ID1#','myprocess','','','POST','frmJournalAccount')
		 }   
	}	 
	
	function purgeJournalAccount(j,a) {
		if (confirm('#vPurgeAccMsg#')) {
			ptoken.navigate('JournalAccount/JournalAccountPurge.cfm?journal='+j+'&account='+a,'contentbox2');
		}
	}
		
</script>

<table width="100%" height="100%">

<tr><td height="30">

		<!--- top menu --->
				
		<table width="100%" border="0" align="center" class="formpadding">		  		
									
			<cfset ht = "58">
			<cfset wd = "58">			
			
			<tr>		
			
				<cfset itm = 0>
				
				<cfset itm = itm+1>			
									
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Accounting/General.png" 
							targetitem = "1"
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							name       = "General Settings"
							class      = "highlight1"
							source 	   = "javascript:journal()">
							
				<cfset itm = itm+1>													
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Accounting/Accounts.png" 
							iconwidth  = "#wd#" 
							targetitem = "2"
							iconheight = "#ht#" 
							name       = "Accounts"
							source 	   = "javascript:glaccount()">							
							
				<cfset itm = itm+1>													
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Accounting/Actions.png" 
							iconwidth  = "#wd#" 
							targetitem = "2"
							iconheight = "#ht#" 
							name       = "Journal Actions"
							source 	   = "javascript:journal_action()">
							
						
							
				<cfset itm = itm+1>													
				<cf_menutab item       = "#itm#" 
				            iconsrc    = "Logos/Accounting/CostCenter.png" 
							iconwidth  = "#wd#" 
							targetitem = "2"
							iconheight = "#ht#" 
							name       = "Cost Center"
							source 	   = "javascript:costcenter()">			

				
														 		
				</tr>
		</table>

	</td>
 </tr>
 </cfoutput>
 
<tr><td height="1" colspan="1" class="linedotted"></td></tr>

<tr><td valign="top">
	
	<table width="100%" 	    
		  height="100%"
		  align="center">
	 		
			<!--- <tr class="hide"><td valign="top" height="100" id="result" name="result"></td></tr> --->

			<cf_menucontainer item="1" class="regular">		
				<cfinclude template="JournalEdit.cfm">
			</cf_menucontainer>							
			
			<cf_menucontainer item="2" class="hide">
			
	</table>

</td></tr>

</table>

