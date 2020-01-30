<cfoutput>
	<script src='#SESSION.root#/Scripts/Color/spectrum.js'></script>
	<link rel='stylesheet' href='#SESSION.root#/Scripts/Color/spectrum.css' />
</cfoutput>
<script>
	function colorInitialize()
	{
		
		
         $("input[type=color]").each(function() {

	        var str = $(this).attr('id')
			var config = $('#__'+str).val();
			var obj = jQuery.parseJSON(config);
			
			$(this).spectrum(obj);


         });
		
	}

</script>