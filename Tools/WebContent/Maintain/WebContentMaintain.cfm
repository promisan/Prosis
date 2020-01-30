

<!--- maintain webcontent --->

<cfparam name="Attributes.SystemFunctionId"  default="">
<cfparam name="Attributes.ContentId"         default="">

<cfif attributes.systemfunctionid neq "">
	
		<cfquery name="content" datasource="AppsSystem">

			SELECT *
			FROM   Ref_ModuleControlContent
			WHERE  ContentId        = '#Attributes.ContentId#'
			AND    SystemFunctionId = '#Attributes.SystemFunctionId#'

		</cfquery>

		<cfquery name="language" datasource="AppsSystem">

			SELECT *
			FROM   Ref_SystemLanguage
			WHERE  Operational = '2'
			
		</cfquery>
		
		<cfoutput>
		
			<form name="languageform" id="languageform" action="#SESSION.root#/Tools/Webcontent/Maintain/WebcontentSubmit.cfm" method="post"> 
			
				<cfloop query="language">
					<b>#Language.LanguageName#</b> </br>
					<textarea name="Text#Language.Code#" id="Text#Language.Code#" style="width:100%; height:150px">#Evaluate("content.Text#Language.Code#")#</textarea></br></br>
				</cfloop>

				<input type="hidden" id="ContentId" name="ContentId" value="#Attributes.ContentId#">
				<input type="hidden" id="SystemFunctionId" name="SystemFunctionId" value="#Attributes.SystemFunctionId#">
				
				<input type="submit" id="submit" name="submit" value="save">
			</form>
			
		</cfoutput>
		
</cfif>