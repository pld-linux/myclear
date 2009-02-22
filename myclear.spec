#
%include        /usr/lib/rpm/macros.perl
Summary:	Command for clearing to bottom of terminal instead of top
Summary(pl.UTF-8):	Komenda czyszcząca terminal do dołu zamiast do góry
Name:		myclear
Version:	20030322.0
Release:	1
License:	BSD-like + request for feedback (see COPYING)
Group:		Applications
# based on http://jetmore.org/john/code/myclear
Source0:	%{name}.pl
URL:		http://jetmore.org/john/code/#myclear
BuildRequires:	perl-tools-pod
BuildRequires:	rpm-perlprov
Suggests:	perl-perldoc
BuildArch:	noarch
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%description
Command for clearing to bottom of terminal instead of top.

%description -l pl.UTF-8
Komenda działająca podonie do clear, z tą różnicą, że czyści terminal
do dołu zamiast do góry.

%prep
%setup -q -c -T

cat << EOF > COPYING
Copyright (c) 2003 John Jetmore <jj33@pobox.com>.  All rights reserved.  This
code freely redistributable provided my name and this copyright notice are not
removed.  Send email to the contact address if you use this program.
EOF

%build
pod2man %SOURCE0 > %{name}.1
pod2text %SOURCE0 > %{name}.txt

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT{%{_bindir},%{_mandir}/man1}

install %SOURCE0 $RPM_BUILD_ROOT%{_bindir}/%{name}
install %{name}.1 $RPM_BUILD_ROOT%{_mandir}/man1/%{name}.1

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%attr(755,root,root) %{_bindir}/%{name}
%{_mandir}/man1/%{name}.1*
%doc COPYING %{name}.txt
