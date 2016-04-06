type html

type page = {
  url : string ; (* local url, same as filename *)
  content : html
}

type sitemap = {
  pages : page list ;
  dirs  : directory list
}

and directory = {
  name : string ;
  content : sitemap
}

(** A website is a homepage and a sitemap (which does not include the index) *)
type website = page * sitemap
