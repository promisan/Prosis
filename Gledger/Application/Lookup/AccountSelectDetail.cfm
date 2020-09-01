<cfparam name="URL.IDParent" default="">
<cfparam name="URL.Crit"     default="">
<cfparam name="URL.Field"    default="">
<cfparam name="URL.Filter"   default="">

<!--- provision to select only mission --->

    <cfquery name="Parameter" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
	</cfquery>
	
	<cfif url.filter neq "">
		
		<cfset fil = "">
	    <cfloop index="itm" list="#url.filter#" delimiters="|">
	   
		   <cfif fil eq "">
		      <cfset fil = "'#itm#'">
		   <cfelse>
		      <cfset fil = "#fil#,'#itm#'">	  
		   </cfif>
	   	  
	    </cfloop>	
		
	</cfif>
			
	<cfquery name="Ledger" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT A.*, G.Description as GroupDescription 
	    FROM   Ref_Account A, Ref_AccountGroup G
		WHERE  A.AccountGroup = G.AccountGroup 
		
		<cfif URL.IDParent neq "">
		AND    G.AccountParent = '#URL.IDParent#'
		</cfif>
		
		<cfif url.journal neq "">
		AND   (		
				ForceCurrency = (SELECT Currency 
		                         FROM   Journal 
								 WHERE  Journal = '#url.journal#') 
								
				OR ForceCurrency = '' 
				OR ForceCurrency is NULL
				)	
		</cfif>
		
		<cfif URL.Crit neq "">
		AND   (A.GLAccount LIKE '%#URL.Crit#%' OR A.Description LIKE '%#URL.Crit#%')
		</cfif>
		<cfif url.mission neq "">
		AND   GLAccount IN (SELECT GLAccount 
		                    FROM   Ref_AccountMission 
							WHERE  Mission = '#URL.Mission#')
		</cfif>
		<cfif url.filter neq "">
		
			<cfif url.field eq "parent">
				AND G.AccountParent IN (#preservesingleQuotes(fil)#)
			<cfelse>
				AND A.#url.field# IN (#preservesingleQuotes(fil)#)
				
			</cfif>
			
		</cfif>
		ORDER BY A.AccountGroup
				
	</cfquery>	
		
     <table width="98%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
	 <TR class="line labelmedium fixrow"> 
       <td width="8%" height="19" ></td>
       <TD width="20%"><cf_tl id="Account"></TD>
       <TD width="50%"><cf_tl id="Description"></TD>
	   <TD width="8%"><cf_tl id="Type"></TD>
	   <TD width="8%"><cf_tl id="Class"></TD>	  
     </TR>
			 
	 <cfoutput query="Ledger" group="AccountGroup">
	 
	    <tr class="line labelmedium">	 				
			<td style="padding-top:12px;padding-left:5px;font-weight:200;font-size:20px;height:45px;" colspan="5" align="left">#GroupDescription# <font size="2">#AccountGroup#</td> 
		</TR>
		
	 <cfoutput>
	 
		 <cfset des = replace(description,"'","","ALL")>
			 
		 <TR class="navigation_row line labelmedium" style="height:15px">
		     <cfif url.mode eq "cfwindow">
			 <TD class="navigation_action"
			   onclick="setvalue('#GLAccount#')" style="padding-top:4px;padding-left:20px"><cf_img icon="select"></td>			 							  
			 <TD>
			 <cfelse>
			 <TD class="navigation_action"
			   onclick="selected('#GLAccount#','#AccountType#','#Des#','#forceprogram#')" style="padding-top:4px;padding-left:20px"><cf_img icon="select"></td>			 							  
			 <TD>
			 </cfif>
			 <cfif url.mission neq "">
			 <cf_getGLaccount mission="#url.mission#" glaccount="#glaccount#">
			 <cfelse>
			 #glaccount# #forceCurrency#
			 </cfif>
			 </TD>
		     <TD>#Description#</TD>
			 <TD>#AccountType#</TD>
			 <TD>#AccountClass#</TD>
		 </tr>
	
	 </cfoutput>
	 
	 </cfoutput>
	 </table>
	 	
<cfset AjaxOnLoad("doHighlight")>	

<script>
	Prosis.busy("no")	
</script>
  