
<cfoutput>

<script>
  <!--- reload the calendar if opened from a calendar --->
  try {
   opener.document.getElementById('calendarreload').click()
    } catch(e) {}
  <!--- releoad the listing if opened from a listing --->  
  try { opener.applyfilter('1','','#url.workactionid#');
    } catch(e) {} 
</script>

</cfoutput>