'use strict';

window.onload = function()
{
  var el_lectures = document.getElementById('lectures');
  if (el_lectures)
  {
    var upcoming = [];
    var past = [];

    var current_date = Date.now();
    var el_all_lectures = el_lectures.getElementsByTagName('ul')[0];

    // read all lectures and sort into `upcoming` and `past`
    for (var i = 0; i < el_all_lectures.children.length; i++)
    {
      var el_lecture = el_all_lectures.children[i];
      var lecture_date = new Date(el_lecture.getAttribute('data-date'));
      if (lecture_date < current_date)
        past.push(el_lecture);
      else
        upcoming.push(el_lecture);
    }

    // generate list of upcoming lectures
    if (upcoming.length > 0)
    {
      var h = document.createElement('h3');
      h.textContent = 'Upcoming lectures';
      el_lectures.appendChild(h);

      var ul = document.createElement('ul');
      for (var i = upcoming.length - 1; i >= 0; i--)
        ul.appendChild(upcoming[i]);
      el_lectures.appendChild(ul);
    }

    // generate list of past lectures
    if (past.length > 0)
    {
      var h = document.createElement('h3');
      h.textContent = 'Past lectures';
      el_lectures.appendChild(h);

      var ul = document.createElement('ul');
      for (var i = 0; i < past.length; i++)
        ul.appendChild(past[i]);
      el_lectures.appendChild(ul);
    }

    el_lectures.removeChild(el_all_lectures);
  }
}

// vim: ts=2:sts=2:sw=2:et
