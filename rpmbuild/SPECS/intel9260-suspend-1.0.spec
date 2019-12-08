Name:           intel9260-suspend
Version:        1.0
Release:        1%{?dist}
Summary:        Scripts to allow proper suspending on Intel 9260 devices.

License:        MIT
URL:            https://pobe.ga/
Source0:        intel9260-suspend-1.0.tar.gz

BuildArch:      noarch

%description
Scripts to allow proper suspending on Intel 9260 devices.

%prep
%autosetup

%build

%install
rm -rf $RPM_BUILD_ROOT
install -d -m 0755 $RPM_BUILD_ROOT/etc/udev/rules.d/
install -m 0755 80-intel9260-btusb.rules $RPM_BUILD_ROOT/etc/udev/rules.d/80-intel9260-btusb.rules
install -d -m 0755 $RPM_BUILD_ROOT/usr/lib/systemd/system-sleep
install -m 0755 bluetooth.sh $RPM_BUILD_ROOT/usr/lib/systemd/system-sleep/bluetooth.sh


%files
/etc/udev/rules.d/80-intel9260-btusb.rules
/usr/lib/systemd/system-sleep/bluetooth.sh

%changelog
* Sun Dec  8 2019 pobega
- 
