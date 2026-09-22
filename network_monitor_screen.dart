import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

enum RequestStatus { idle, loading, queued, completed }

class NetworkMonitorScreen extends StatefulWidget {
  const NetworkMonitorScreen({super.key});
  static const routeName = '/network-monitor';

  @override
  State<NetworkMonitorScreen> createState() => _NetworkMonitorScreenState();
}

class _NetworkMonitorScreenState extends State<NetworkMonitorScreen> {
  final _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  List<ConnectivityResult> _network = const [ConnectivityResult.none];
  Timer? _transfer;
  RequestStatus _status = RequestStatus.idle;
  int _progress = 0;
  String _message = 'Listening for real-time network changes…';

  bool get _online => _network.any((item) => item != ConnectivityResult.none);
  String get _interface => _network.contains(ConnectivityResult.wifi)
      ? 'Wi-Fi'
      : _network.contains(ConnectivityResult.mobile)
      ? 'Cellular'
      : _network.contains(ConnectivityResult.ethernet)
      ? 'Ethernet'
      : 'Offline';

  @override
  void initState() {
    super.initState();
    _watchNetwork();
  }

  Future<void> _watchNetwork() async {
    _onNetworkChange(await _connectivity.checkConnectivity());
    _subscription = _connectivity.onConnectivityChanged.listen(_onNetworkChange);
  }

  void _onNetworkChange(List<ConnectivityResult> value) {
    final wasOnline = _online;
    if (!mounted) return;
    setState(() {
      _network = value;
      _message = 'Active interface: $_interface';
    });
    if (wasOnline && !_online && _status == RequestStatus.loading) {
      _queue('Connection lost during handover. Request queued at $_progress%.');
    }
    if (!wasOnline && _online && _status == RequestStatus.queued) {
      _runTransfer(resuming: true);
    }
  }

  void _startRequest() {
    if (_online) {
      _runTransfer(resuming: false);
    } else {
      _queue('Offline: request saved in queue and will retry automatically.');
    }
  }

  void _runTransfer({required bool resuming}) {
    _transfer?.cancel();
    setState(() {
      _status = RequestStatus.loading;
      if (!resuming) _progress = 0;
      _message = resuming ? 'Connection restored on $_interface. Resuming request…' : 'Fetching large dataset…';
    });
    _transfer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (!_online) {
        _queue('Connection lost during handover. Request queued at $_progress%.');
      } else if (mounted) {
        setState(() => _progress += 5);
        if (_progress >= 100) {
          timer.cancel();
          setState(() {
            _progress = 100;
            _status = RequestStatus.completed;
            _message = 'Dataset received successfully on $_interface.';
          });
        }
      }
    });
  }

  void _queue(String text) {
    _transfer?.cancel();
    if (mounted) setState(() { _status = RequestStatus.queued; _message = text; });
  }

  @override
  void dispose() { _transfer?.cancel(); _subscription?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final color = _online ? Colors.green : Colors.red;
    return Scaffold(
      appBar: AppBar(title: const Text('Network Monitor')),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
            CircleAvatar(radius: 28, backgroundColor: color.withValues(alpha: .15), foregroundColor: color, child: Icon(_online ? (_interface == 'Wi-Fi' ? Icons.wifi : Icons.signal_cellular_alt) : Icons.wifi_off, size: 30)),
            const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_interface, style: Theme.of(context).textTheme.headlineSmall), Text(_online ? 'Connection available' : 'No connection available')])),
          ]))),
          const SizedBox(height: 18), Text('Request recovery demo', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 10),
          LinearProgressIndicator(value: _progress / 100, minHeight: 10, borderRadius: BorderRadius.circular(8)), const SizedBox(height: 8),
          Text('$_progress% · ${_status.name.toUpperCase()}'), const SizedBox(height: 16),
          FilledButton.icon(onPressed: _status == RequestStatus.loading ? null : _startRequest, icon: const Icon(Icons.cloud_download_outlined), label: Text(_status == RequestStatus.queued ? 'Retry queued request' : 'Fetch large dataset')),
          const SizedBox(height: 18), Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(_message))),
          const Spacer(), Text('Demo: start a request, turn Wi-Fi off/on or switch to mobile data. The request queues offline and resumes automatically.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
        ]),
      )),
    );
  }
}
