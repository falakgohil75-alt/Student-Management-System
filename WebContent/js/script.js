// ---------- Sidebar toggle (mobile) ----------
document.addEventListener('DOMContentLoaded', function () {
  var btn = document.getElementById('menuBtn');
  var sidebar = document.getElementById('sidebar');
  if (btn && sidebar) {
    btn.addEventListener('click', function () { sidebar.classList.toggle('open'); });
  }

  // ---------- Auto-hide success alerts after 4 seconds ----------
  document.querySelectorAll('.alert-success').forEach(function (a) {
    setTimeout(function () { a.style.display = 'none'; }, 4000);
  });

  // ---------- Date limits: DOB cannot be in the future ----------
  var today = new Date().toISOString().split('T')[0];
  var dob = document.getElementById('dob');
  if (dob) dob.setAttribute('max', today);

  // ---------- Client-side form validation ----------
  // Uses the HTML5 rules written on each field (required, pattern, min, max, type)
  document.querySelectorAll('form.needs-validation').forEach(function (form) {
    form.addEventListener('submit', function (e) {
      var valid = true;
      form.querySelectorAll('input, select, textarea').forEach(function (field) {
        var msg = field.parentElement.querySelector('.field-error');
        if (field.type === 'hidden') return;
        if (!field.checkValidity()) {
          valid = false;
          field.classList.add('invalid');
          if (msg) msg.textContent = field.title || field.validationMessage;
        } else {
          field.classList.remove('invalid');
          if (msg) msg.textContent = '';
        }
      });
      if (!valid) {
        e.preventDefault();
        var first = form.querySelector('.invalid');
        if (first) first.focus();
      }
    });
  });

  // ---------- Show / hide password on login ----------
  var toggle = document.getElementById('togglePw');
  var pw = document.getElementById('password');
  if (toggle && pw) {
    toggle.addEventListener('click', function () {
      var show = pw.type === 'password';
      pw.type = show ? 'text' : 'password';
      toggle.textContent = show ? 'Hide' : 'Show';
    });
  }
});

// ---------- Delete confirmation (called from onsubmit of delete forms) ----------
function confirmDelete(what, name) {
  return confirm('Are you sure you want to delete ' + what + ' "' + name + '"?\nThis action cannot be undone.');
}
