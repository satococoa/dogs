window.addEventListener('load', function(event) {
	var sel = document.getElementById('kenshu');
	sel.addEventListener('change', function(e) {
		var target = e.target;
		target.form.submit();
	}, false);
}, false);