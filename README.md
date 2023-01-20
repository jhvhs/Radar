## Radar

Radar is a macOS menubar application for monitoring private pipelines in Concourse.

### Requirements

- macOS Ventura (13.0) and above

### Configuration

To monitor pipelines, Radar needs three values, all of which can be set in the
_Preferences_ window:

1. **Concourse URL** - the main URL of the Concourse dashboard
2. **Team name** - Radar will filter out all the pipelines that don't belong to this team
3. **Auth token** - once the first two fields are filled in, the app menu should
  show an extra item _Fetch token_. Clicking that will open the browser with a
  Concourse web page for sending the token to fly. If that page fails to send the token,
  it can still be manually set in the _Preferences_ window.

### Limitations

Currently, the app is limited to monitoring a single team on a single server.
It is sufficient in many cases, but there are plans to expand the scope of
the app beyond those limits.

### Development requirements

- Xcode 14.1 and above
