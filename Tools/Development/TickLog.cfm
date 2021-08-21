<cfparam name="Attributes.Init"   default = GetTickCount()>
<cfparam name="Attributes.Step"   default = "0">
<cfparam name="Caller.ThisTick"   default = "0">
<cfparam name="Attributes.Memo"   default = "">
<cfparam name="Operational"       default = "0">

<cfset ThisTick =GetTickCount()>
<cfset lineBreak = Chr(13) & Chr(10)>

<cfif operational eq "1">
	
	<cfsilent>
	<cfif Attributes.Step neq "0">
		 
		<cf_logpoint mode="append" fileName="Thick.txt">
			<cfoutput>
				#lineBreak#
				From start: #ThisTick - Attributes.Init# milisecs Step: #Attributes.Step#
				#lineBreak#
				From previous: #ThisTick - caller.PreviousTick# milisecs
				#lineBreak#			
				Memo :  #Attributes.Memo# 			
			</cfoutput>
		</cf_logpoint>
		
	<cfelse>
	
		<cf_logpoint fileName="Thick.txt">
		
			<cfoutput>
				#lineBreak#			
				From start: #ThisTick - Attributes.Init# milisecs Step: #Attributes.Step#
				#lineBreak#
				From previous : #ThisTick - caller.PreviousTick# milisecs
				#lineBreak#			
				Memo :  #Attributes.Memo#
			</cfoutput>
			
		</cf_logpoint>		
		
	</cfif>
			
	</cfsilent>

</cfif>

<cfset caller.PreviousTick = ThisTick>			