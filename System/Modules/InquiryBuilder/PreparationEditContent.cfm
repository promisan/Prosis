
<!--- edit screen for SQL.cfm --->

<cf_screentop label="Pre Query Preparation" height="100%" scroll="No" banner="blue" html="No"  layout="webapp" close="parent.ColdFusion.Window.destroy('myscript',true)">

<cfif ParameterExists(Form.Save)>

	<cfquery name="Log" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_ModuleControlDetailLog
		(SystemFunctionId,
		 FunctionSerialNo,
		 PreparationScript,
		 OfficerUserId,
		 OfficerLastName,OfficerFirstName)
		VALUES
		('#url.systemfunctionid#',
		 '#url.functionserialno#',
		 '#Form.SQL#',
		 '#SESSION.acc#',
		 '#SESSION.last#','#SESSION.first#')		
	</cfquery> 

	<cfquery name="Module" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE    Ref_ModuleControlDetail
		SET       PreparationScript = '#Form.SQL#'
		WHERE     SystemFunctionId = '#url.systemfunctionid#' 
		AND       FunctionSerialNo = '#url.functionserialno#'   
	</cfquery> 

   <script>
	    window.close()
   </script>      
   
</cfif>

<table height="100%" width="100%" cellspacing="0" cellpadding="0">

<cfform action="PreparationEditContent.cfm?SystemFunctionId=#url.systemfunctionid#&FunctionSerialNo=#url.functionserialNo#" method="post">

<tr><td width="97%" style="padding: 4;" bgcolor="ffffef" class="labelmedium">
        <font color="gray">Create regular coldfusion query scripts like: <b>&nbsp;&nbsp;&nbsp; [cfquery name="Module" datasource="AppsSystem"] &nbsp;&nbsp;&nbsp;&nbsp;[/cfquery]<br></b>
		
		<br>
		which must generate a temporary tables (INSERT INTO) with the name <b>userquery.dbo.#answer1#, userquery.dbo.#answer2#</b> which you may use in the final listing script in those cases that your query is complex and can not be used in one single SQL select statement.
		In the SELECT query field you must refer to the temp tables as <b>@answer1 etc.</b>
		
		</td>
</tr>
<tr><td width="97%" style="padding: 4;" bgcolor="ffffef"><font color="gray"><i>User the following reserved keywords to make your query dynamic : <b>#SESSION.acc#</b> (useraccount), #SESSION.last# (lastName) #SESSION.first# (firstname)</b></td></tr>		

<tr><td height="1" class="line"></td></tr>

<tr class="line"><td align="center" height="35">

	<input type="button" name="Cancel" id="Cancel" style="width:100" value="Cancel" class="button10g" onclick="parent.ColdFusion.Window.destroy('myscript',true)">
	<input type="submit" name="Save" id="Save" style="width:100" value="Save" class="button10g">
		
	<cfif ParameterExists(Form.Format)>
	<input type="submit" name="Edit" id="Edit" style="width:100" value="Edit" class="button10g">	
	<cfelse>
	<input type="submit" name="Format" id="Format" style="width:100" value="Formatted" class="button10g">	
	</cfif>
	
</td></tr>

<tr><td height="100%" valign="top">

<cfif ParameterExists(Form.Edit) or ParameterExists(Form.Format)>


    <!--- take content from form --->
	<cfset content = form.SQL>
	
	<cfif ParameterExists(Form.Edit)>
	
		<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td>
	
		<cfoutput>
		<textarea name="SQL"
	          class="regular0"
	          style="width: 100%; height: 100%; word-break: break-all;">#content#</textarea>
		</cfoutput>
		
		</td></tr></table>	
		
	<cfelse>
	
		<table width="100%" height="100%">
		<tr>
		<td class="hide">
		
		<cfoutput>
		<textarea name="SQL"	         
	          style="font-size:15px;padding:7px;width: 100%; height: 100%; word-break: break-all;">#content#</textarea>
		</cfoutput>
		
		</td>
		</tr>
		
		<tr>
		<td valign="top" height="100%">
	
		<cfinvoke component="Service.Presentation.ColorCode"  
			      method="colorstring" 
			      datastring="#content#" 
			      returnvariable="result">			
	              <cfset result = replace(result, "�", "", "all") />
				  <cfoutput>			   			  
				  #result#	
				  </cfoutput>
				  
		</td>		  
				  
		</tr></table>		  
	
	</cfif>	

<cfelse> 

	<cfquery name="Module" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM Ref_ModuleControlDetail		
		WHERE     SystemFunctionId = '#url.systemfunctionid#' 
		AND       FunctionSerialNo = '#url.functionserialno#'   
	</cfquery>   
		
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td>
		
	<cfset content = replace(Module.preparationscript, "''","''''", "ALL")> 
	<cfif content eq "">
	
<cfsavecontent variable="init">
[cfquery name="myListingQuery" datasource="AppsNNNNNN">

SELECT *
INTO userQuery.dbo.#answer1#

[/cfquery>		  
</cfsavecontent>
			
	<textarea name="SQL"
	          class="regular0"
	          style="font-size:15px;padding:7px;width: 100%; height: 100%; word-break: break-all;"><cfoutput>#replace(init, "[","<", "ALL")#</cfoutput> 
  </textarea>
	
	<cfelse>
	
	<cfoutput>
		
	<textarea name="SQL"
	          class="regular0"
	          style="font-size:15px;padding:7px;width: 100%; height: 100%; word-break: break-all;">#content#</textarea>
			  
	</cfoutput>		  
	
	</cfif>	
	
	
	</td></tr></table>
	
</cfif>	

</td></tr>

</cfform>

</table>
