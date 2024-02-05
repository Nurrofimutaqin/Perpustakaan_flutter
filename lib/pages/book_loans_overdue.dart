import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:perpustakaan/pages/detail_peminjaman.dart';
import 'package:perpustakaan/providers/api_loans.dart';

class BookLoansOverdue extends StatelessWidget {
  Loans loan = Loans();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Book Loans Overdue List'),
        ),
        body: Container(
            child: FutureBuilder<List<dynamic>>(
                future: loan.LoansListOverdue(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data!.length == 0) {
                    return Center(child: Text('Not Result'));
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var peminjaman = snapshot.data?[index];
                          String status = peminjaman["status"]
                              ? "Returned"
                              : "Not Returned";
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              tileColor: Colors.grey.withOpacity(0.1),
                              title: Text(peminjaman['buku_judul']),
                              subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal pinjam : ${peminjaman["tanggal_pinjam"]}'),
                                Text('Due Date:  ${peminjaman["tanggal_kembali"]}')
                              ],
                            ),
                              trailing: Text(status),
                              onTap: () async {
                                var peminjamanId = peminjaman['id'];
                                print(peminjamanId);
                                var selectedloan =
                                    await loan.getPeminjamanById(peminjamanId);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailPeminjaman(detail: selectedloan)),
                                );
                              },
                            ),
                          );
                        });
                  }
                })));
  }
}
