import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PushMoviesScreen extends StatelessWidget {
  const PushMoviesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Movies to Firestore'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await pushMovies();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Movies pushed successfully!')),
            );
          },
          child: const Text('Push Movies'),
        ),
      ),
    );
  }

  Future<void> pushMovies() async {
    final List<Map<String, dynamic>> movies = [
      {
        'title': 'Atlas',
        'image': 'https://www.impawards.com/2024/posters/atlas.jpg',
        'year': '2024',
        'genre': 'Fiksi Ilmiah',
        'deskripsi':
            'Jennifer Lopez berperan sebagai seorang analis kontra-terorisme yang skeptis terhadap kecerdasan buatan, namun harus mengandalkannya setelah misi menangkap robot nakal gagal. Dalam perjalanannya, ia mulai mempertanyakan batasan moral antara manusia dan teknologi.'
      },
      {
        'title': 'Emilia Pérez',
        'image': 'https://www.impawards.com/2024/posters/emilia_perez.jpg',
        'year': '2024',
        'genre': 'Musikal Kriminal',
        'deskripsi':
            'Zoe Saldaña membintangi film musikal kriminal yang mengisahkan perjalanan seorang wanita dalam dunia kejahatan. Sepanjang film, Emilia menyadari bahwa ia terlahir dengan bakat unik dalam musik yang membantunya menavigasi kehidupan yang penuh bahaya.'
      },
      {
        'title': 'Twisters',
        'image': 'https://www.impawards.com/2024/posters/twisters.jpg',
        'year': '2024',
        'genre': 'Thriller Bencana',
        'deskripsi':
            'Sekuel dari film "Twister" yang menampilkan petualangan baru dalam menghadapi badai tornado yang mematikan. Sekelompok ilmuwan dan pemburu badai berusaha melawan tornado terbesar yang pernah tercatat, menggunakan teknologi canggih untuk memahami fenomena alam yang semakin menjadi ancaman global.'
      },
      {
        'title': 'Thelma',
        'image': 'https://www.impawards.com/2024/posters/thelma.jpg',
        'year': '2024',
        'genre': 'Komedi Aksi',
        'deskripsi':
            'Kisah seorang wanita berusia 93 tahun yang memulai perjalanan balas dendam yang penuh aksi dan humor. Dalam perjalanannya, ia bertemu dengan berbagai karakter yang membantunya memulai perjalanan balas dendam yang penuh aksi, humor, dan kejutan.'
      },
      {
        'title': 'Close to You',
        'image': 'https://www.impawards.com/2024/posters/close_to_you.jpg',
        'year': '2024',
        'genre': 'Drama',
        'deskripsi':
            'Elliot Page membintangi drama yang mendalam tentang hubungan dan identitas. Film ini menggali isu-isu seputar cinta, penerimaan, dan pencarian makna hidup dalam dunia yang tidak selalu ramah.'
      },
      {
        'title': 'Widow Clicquot',
        'image': 'https://www.impawards.com/2024/posters/widow_clicquot.jpg',
        'year': '2024',
        'genre': 'Drama Sejarah',
        'deskripsi':
            'Mengisahkan kehidupan Barbe-Nicole Ponsardin, janda muda yang membangun kerajaan sampanye di Prancis abad ke-19. Film ini mengisahkan perjuangan dan kegigihan seorang wanita dalam menghadapi tantangan besar di dunia perdagangan yang dikuasai pria.'
      },
      {
        'title': 'Hot Frosty',
        'image': 'https://www.impawards.com/2024/posters/hot_frosty.jpg',
        'year': '2024',
        'genre': 'Komedi Romantis Fantasi',
        'deskripsi':
            'Cerita cinta yang unik antara manusia dan makhluk fantasi dalam setting musim dingin yang ajaib. Ketika musim dingin yang abadi mengancam dunia, keduanya harus bekerja sama untuk mengatasi rintangan dan menemukan cara untuk mencairkan hati mereka yang keras.'
      },
      {
        'title': 'Pedro Páramo',
        'image': 'https://www.impawards.com/2024/posters/pedro_paramo.jpg',
        'year': '2024',
        'genre': 'Drama',
        'deskripsi':
            'Adaptasi dari novel klasik Meksiko yang mengeksplorasi tema cinta, kematian, dan penebusan. Film ini mengisahkan perjalanan seorang pria muda yang mencari ayahnya di sebuah desa terpencil, menemukan dunia yang penuh dengan roh-roh, kenangan, dan misteri.'
      },
      {
        'title': 'Vijay 69',
        'image': 'https://www.impawards.com/2024/posters/vijay_69.jpg',
        'year': '2024',
        'genre': 'Drama Olahraga',
        'deskripsi':
            'Kisah inspiratif tentang seorang atlet veteran yang berjuang untuk kembali ke puncak kariernya. Dengan fisik yang mulai menua, Vijay berusaha keras untuk melawan waktu dan membuktikan bahwa usia bukanlah penghalang dalam mencapai impian.'
      },
      {
        'title': 'La Lección de Piano',
        'image':
            'https://www.impawards.com/2024/posters/la_leccion_de_piano.jpg',
        'year': '2024',
        'genre': 'Drama Musik',
        'deskripsi':
            'Perjalanan emosional seorang pianis muda dalam mengejar mimpinya di dunia musik klasik. Film ini mengeksplorasi tema tentang perjuangan pribadi, pengorbanan, dan cinta terhadap seni.'
      },
      {
        'title': 'Deadpool & Wolverine',
        'image':
            'https://www.impawards.com/2024/posters/deadpool_wolverine.jpg',
        'year': '2024',
        'genre': 'Aksi, Superhero',
        'deskripsi':
            'Film ini menggabungkan karakter Deadpool dan Wolverine dalam petualangan penuh aksi dan humor. Mereka harus bekerja sama untuk menghadapi ancaman besar yang mengancam dunia, dengan pertarungan epik dan dialog yang tajam.'
      },
      {
        'title': 'Transformers One',
        'image': 'https://www.impawards.com/2024/posters/transformers_one.jpg',
        'year': '2024',
        'genre': 'Aksi, Fiksi Ilmiah',
        'deskripsi':
            'Prekuel animasi dari seri Transformers yang mengisahkan asal-usul konflik antara Autobots dan Decepticons. Film ini menawarkan pandangan baru tentang dunia Transformers dengan animasi yang memukau.'
      },
      {
        'title': 'Let Go',
        'image': 'https://www.impawards.com/2024/posters/let_go.jpg',
        'year': '2024',
        'genre': 'Drama',
        'deskripsi':
            'Film drama Swedia ini bercerita tentang seorang perempuan bernama Stella. Dalam banyak hal, ia memegang kendali. Namun, dalam rumah tangga, Stella benar-benar kewalahan. Putra kecilnya selalu menuntut perhatian dan suasana hati putri remajanya sering berubah-ubah. Ditambah dengan ketidakhadiran sang suami secara emosional membuat Stella benar-benar putus asa. Namun, semua berubah ketika ia menerima sebuah pesan.'
      },
      {
        'title': 'Arcane Season 2',
        'image': 'https://www.impawards.com/2024/posters/arcane_season_2.jpg',
        'year': '2024',
        'genre': 'Animasi, Aksi',
        'deskripsi':
            'Lanjutan dari seri animasi populer yang mengisahkan konflik antara dua kota, Piltover dan Zaun. Musim kedua ini melanjutkan petualangan karakter-karakter utama dalam menghadapi tantangan baru dan konflik yang semakin kompleks.'
      },
      {
        'title': 'Rhythm + Flow: Brazil',
        'image':
            'https://www.impawards.com/2024/posters/rhythm_flow_brazil.jpg',
        'year': '2024',
        'genre': 'Musik, Kompetisi',
        'deskripsi':
            'Versi Brasil dari seri kompetisi musik yang menampilkan talenta-talenta hip-hop terbaik dari seluruh negeri. Para peserta bersaing dalam berbagai tantangan untuk memperebutkan gelar juara dan kontrak rekaman.'
      },
      {
        'title': 'Jungle Night',
        'image': 'https://www.impawards.com/2024/posters/jungle_night.jpg',
        'year': '2024',
        'genre': 'Aksi, Petualangan',
        'deskripsi':
            'Sekelompok wisatawan yang terjebak di hutan belantara Amazon berjuang untuk bertahan hidup dan melawan ancaman dari alam dan makhluk buas yang mengancam mereka. Film ini menampilkan aksi penuh ketegangan dan keseruan petualangan di hutan.'
      },
      {
        'title': 'The Shadow Strays',
        'image': 'https://www.impawards.com/2024/posters/the_shadow_strays.jpg',
        'year': '2024',
        'genre': 'Horror, Thriller',
        'deskripsi':
            'Sekelompok remaja terjebak dalam misteri kelam di sebuah desa terpencil, menghadapi teror dari makhluk gaib yang mengancam nyawa mereka. Ketegangan dan horor memuncak di setiap sudut film ini.'
      },
      {
        'title': 'Ipar Adalah Maut',
        'image': 'https://www.impawards.com/2024/posters/ipar_adalah_maut.jpg',
        'year': '2024',
        'genre': 'Comedy, Thriller',
        'deskripsi':
            'Seorang pria terjebak dalam situasi pelik setelah iparnya datang berkunjung. Kekacauan dan konflik bermunculan, memicu tawa dan ketegangan yang tak terduga di setiap adegan.'
      },
      {
        'title': 'Janji Darah',
        'image': 'https://www.impawards.com/2024/posters/janji_darah.jpg',
        'year': '2024',
        'genre': 'Drama, Action',
        'deskripsi':
            'Seorang pria berusaha mencari keadilan atas kematian saudaranya. Dalam perjalanan penuh pengorbanan, ia berhadapan dengan konspirasi dan ujian berat terhadap kesetiaan dan keluarganya.'
      },
      {
        'title': 'Borderless Fog',
        'image': 'https://www.impawards.com/2024/posters/borderless_fog.jpg',
        'year': '2024',
        'genre': 'Thriller, Crime',
        'deskripsi':
            'Detektif wanita memecahkan serangkaian pembunuhan di perbatasan Indonesia-Malaysia, mengungkap konspirasi yang mengancam nyawanya.'
      },
      {
        'title': 'Puisi Cinta yang Membunuh',
        'image':
            'https://www.impawards.com/2024/posters/puisi_cinta_yang_membunuh.jpg',
        'year': '2024',
        'genre': 'Drama, Romance',
        'deskripsi':
            'Adaptasi dari novel Garin Nugroho tentang kisah cinta yang rumit di mana puisi menjadi senjata dalam permainan cinta penuh intrik dan pengkhianatan.'
      },
      {
        'title': 'The Night Comes for Us',
        'image':
            'https://www.impawards.com/2024/posters/the_night_comes_for_us.jpg',
        'year': '2024',
        'genre': 'Action, Thriller',
        'deskripsi':
            'Seorang mantan anggota geng berjuang untuk melindungi seorang gadis muda dari ancaman geng kriminal. Aksi brutal dan pertarungan mendebarkan menjadi inti dari film ini.'
      },
      {
        'title': 'Eega',
        'image': 'https://www.impawards.com/2024/posters/eega.jpg',
        'year': '2024',
        'genre': 'Comedy, Fantasy',
        'deskripsi':
            'Seorang pria yang terlahir kembali sebagai seekor lalat setelah dibunuh. Ia bertekad untuk membalas dendam dengan cara yang lucu dan unik.'
      },
      {
        'title': 'Oblivion',
        'image': 'https://www.impawards.com/2024/posters/oblivion.jpg',
        'year': '2024',
        'genre': 'Sci-Fi, Thriller',
        'deskripsi':
            'Di masa depan pasca-apokaliptik, seorang teknisi melindungi sumber daya bumi dari ancaman. Namun, ia menemukan rahasia yang mengguncang pandangannya tentang realitas.'
      },
      {
        'title': '1917',
        'image': 'https://www.impawards.com/2024/posters/1917.jpg',
        'year': '2024',
        'genre': 'War, Drama',
        'deskripsi':
            'Dua tentara Inggris berusaha menyampaikan pesan yang dapat menyelamatkan 1.600 nyawa. Mereka harus melewati garis depan dalam waktu singkat di tengah pertempuran.'
      },
      {
        'title': 'Aftersun',
        'image': 'https://www.impawards.com/2024/posters/aftersun.jpg',
        'year': '2024',
        'genre': 'Drama',
        'deskripsi':
            'Seorang ayah dan putrinya menghabiskan waktu liburan musim panas di sebuah resor. Hubungan mereka berkembang dan menciptakan kenangan yang membentuk masa depan putrinya.'
      },
      {
        'title': 'Blackhat',
        'image': 'https://www.impawards.com/2024/posters/blackhat.jpg',
        'year': '2024',
        'genre': 'Thriller, Crime',
        'deskripsi':
            'Seorang hacker dibebaskan dari penjara untuk melacak peretas internasional yang bertanggung jawab atas serangan siber besar yang mengancam dunia.'
      },
      {
        'title': 'Edge of Tomorrow',
        'image': 'https://www.impawards.com/2024/posters/edge_of_tomorrow.jpg',
        'year': '2024',
        'genre': 'Action, Sci-Fi',
        'deskripsi':
            'Seorang tentara terjebak dalam siklus waktu yang mengulang hari yang sama saat pertempuran melawan alien. Ia harus beradaptasi dan belajar untuk mengalahkan musuh yang tak terlihat.'
      },
      {
        'title': 'Spider-Man: Across the Spider-Verse',
        'image':
            'https://www.impawards.com/2024/posters/spider_man_across_the_spider_verse.jpg',
        'year': '2024',
        'genre': 'Animation, Action',
        'deskripsi':
            'Miles Morales bertemu dengan berbagai versi Spider-Man dari multiverse. Bersama-sama, mereka berusaha untuk mengalahkan ancaman yang mengancam keselamatan semua dunia.'
      },
      {
        'title': 'The Killer',
        'image': 'https://www.impawards.com/2024/posters/the_killer.jpg',
        'year': '2024',
        'genre': 'Thriller, Action',
        'deskripsi':
            'Seorang pembunuh bayaran profesional yang menjadi target setelah misinya gagal. Ia harus bertahan hidup sambil mencari tahu siapa yang mengkhianatinya.'
      },
      {
        'title': 'The Red Sea Diving Resort',
        'image':
            'https://www.impawards.com/2024/posters/red_sea_diving_resort.jpg',
        'year': '2024',
        'genre': 'Action, Drama',
        'deskripsi':
            'Berdasarkan kisah nyata, sekelompok agen Israel menyelamatkan ribuan pengungsi Ethiopia dan membawa mereka ke Israel melalui sebuah resor penyelam yang tersembunyi.'
      },
      {
        'title': 'The Silent Witness',
        'image':
            'https://www.impawards.com/2024/posters/the_silent_witness.jpg',
        'year': '2024',
        'genre': 'Mystery, Thriller',
        'deskripsi':
            'Seorang wanita menjadi satu-satunya saksi dalam kasus pembunuhan yang membingungkan. Ketika hidupnya terancam, ia harus memecahkan misteri dan mengungkap siapa pembunuhnya sebelum terlambat.'
      },
      {
        'title': 'Echoes of the Past',
        'image':
            'https://www.impawards.com/2024/posters/echoes_of_the_past.jpg',
        'year': '2024',
        'genre': 'Drama, Historical',
        'deskripsi':
            'Di sebuah desa kecil, seorang pria muda menemukan warisan keluarganya yang tersembunyi dalam arsip kuno. Ia berusaha mengungkapkan cerita-cerita tragis dan cinta yang telah lama terkubur dalam sejarah.'
      },
      {
        'title': 'The Crimson Code',
        'image': 'https://www.impawards.com/2024/posters/the_crimson_code.jpg',
        'year': '2024',
        'genre': 'Crime, Drama',
        'deskripsi':
            'Seorang mantan agen rahasia harus kembali ke dunia gelap untuk membongkar jaringan kriminal internasional yang mengancam keselamatan dunia. Ia harus memecahkan teka-teki kode yang penuh bahaya.'
      },
      {
        'title': 'Shattered Dreams',
        'image': 'https://www.impawards.com/2024/posters/shattered_dreams.jpg',
        'year': '2024',
        'genre': 'Romance, Drama',
        'deskripsi':
            'Dua sejoli menghadapi kenyataan pahit tentang perbedaan impian hidup mereka. Ketika hubungan mereka mulai retak, mereka harus memutuskan apakah mereka masih bisa bersama atau harus berpisah.'
      },
      {
        'title': 'The Last Hour',
        'image': 'https://www.impawards.com/2024/posters/the_last_hour.jpg',
        'year': '2024',
        'genre': 'Sci-Fi, Thriller',
        'deskripsi':
            'Setelah bencana global yang menghancurkan sebagian besar bumi, sekelompok ilmuwan berusaha menemukan solusi untuk memperpanjang kehidupan manusia dalam sisa waktu yang sangat terbatas.'
      },
      {
        'title': 'Fallen Angels',
        'image': 'https://www.impawards.com/2024/posters/fallen_angels.jpg',
        'year': '2024',
        'genre': 'Fantasy, Action',
        'deskripsi':
            'Dua pahlawan dari dunia yang berbeda dipertemukan untuk melawan kekuatan jahat yang mengancam eksistensi alam semesta. Mereka harus bekerja sama meskipun memiliki tujuan yang bertolak belakang.'
      },
      {
        'title': 'Into the Abyss',
        'image': 'https://www.impawards.com/2024/posters/into_the_abyss.jpg',
        'year': '2024',
        'genre': 'Adventure, Mystery',
        'deskripsi':
            'Seorang penjelajah berani menjelajahi sebuah gua bawah tanah yang belum pernah ditemukan sebelumnya. Ia harus menghadapi ancaman alam dan teka-teki masa lalu yang mempengaruhi nasib hidupnya.'
      },
      {
        'title': 'Venomous Heart',
        'image': 'https://www.impawards.com/2024/posters/venomous_heart.jpg',
        'year': '2024',
        'genre': 'Horror, Thriller',
        'deskripsi':
            'Seorang wanita terjebak dalam hubungan beracun dengan seorang pria yang memiliki rahasia kelam. Ketika semakin banyak petunjuk mengarah pada kebenaran yang mengerikan, ia harus memutuskan untuk bertahan atau melarikan diri.'
      },
      {
        'title': 'The Dreamweaver',
        'image': 'https://www.impawards.com/2024/posters/the_dreamweaver.jpg',
        'year': '2024',
        'genre': 'Fantasy, Adventure',
        'deskripsi':
            'Seorang pemuda yang bisa mengendalikan mimpi orang lain terjebak dalam konspirasi besar. Ia harus menghadapi musuh dari dunia mimpi yang mencoba menguasai dunia nyata.'
      },
      {
        'title': 'The Silent Witness',
        'image':
            'https://www.impawards.com/2024/posters/the_silent_witness.jpg',
        'year': '2024',
        'genre': 'Mystery, Thriller',
        'deskripsi':
            'Seorang wanita menjadi satu-satunya saksi dalam kasus pembunuhan yang membingungkan. Ketika hidupnya terancam, ia harus memecahkan misteri dan mengungkap siapa pembunuhnya sebelum terlambat.'
      },
      {
        'title': 'The Crimson Code',
        'image': 'https://www.impawards.com/2024/posters/the_crimson_code.jpg',
        'year': '2024',
        'genre': 'Crime, Drama',
        'deskripsi':
            'Seorang mantan agen rahasia harus kembali ke dunia gelap untuk membongkar jaringan kriminal internasional yang mengancam keselamatan dunia. Ia harus memecahkan teka-teki kode yang penuh bahaya.'
      },
      {
        'title': 'Shattered Dreams',
        'image': 'https://www.impawards.com/2024/posters/shattered_dreams.jpg',
        'year': '2024',
        'genre': 'Romance, Drama',
        'deskripsi':
            'Dua sejoli menghadapi kenyataan pahit tentang perbedaan impian hidup mereka. Ketika hubungan mereka mulai retak, mereka harus memutuskan apakah mereka masih bisa bersama atau harus berpisah.'
      },
      {
        'title': 'The Last Hour',
        'image': 'https://www.impawards.com/2024/posters/the_last_hour.jpg',
        'year': '2024',
        'genre': 'Sci-Fi, Thriller',
        'deskripsi':
            'Setelah bencana global yang menghancurkan sebagian besar bumi, sekelompok ilmuwan berusaha menemukan solusi untuk memperpanjang kehidupan manusia dalam sisa waktu yang sangat terbatas.'
      },
      {
        'title': 'Fallen Angels',
        'image': 'https://www.impawards.com/2024/posters/fallen_angels.jpg',
        'year': '2024',
        'genre': 'Fantasy, Action',
        'deskripsi':
            'Dua pahlawan dari dunia yang berbeda dipertemukan untuk melawan kekuatan jahat yang mengancam eksistensi alam semesta. Mereka harus bekerja sama meskipun memiliki tujuan yang bertolak belakang.'
      },
      {
        'title': 'Into the Abyss',
        'image': 'https://www.impawards.com/2024/posters/into_the_abyss.jpg',
        'year': '2024',
        'genre': 'Adventure, Mystery',
        'deskripsi':
            'Seorang penjelajah berani menjelajahi sebuah gua bawah tanah yang belum pernah ditemukan sebelumnya. Ia harus menghadapi ancaman alam dan teka-teki masa lalu yang mempengaruhi nasib hidupnya.'
      },
      {
        'title': 'Lullaby for the Lost',
        'image':
            'https://www.impawards.com/2024/posters/lullaby_for_the_lost.jpg',
        'year': '2024',
        'genre': 'Drama, Thriller',
        'deskripsi':
            'Setelah mengalami tragedi yang mengubah hidupnya, seorang wanita muda berusaha mengungkap rahasia keluarganya yang telah lama terkubur, meskipun bahaya terus mengintai setiap langkahnya.'
      },
      {
        'title': 'The Dreamweaver',
        'image': 'https://www.impawards.com/2024/posters/the_dreamweaver.jpg',
        'year': '2024',
        'genre': 'Fantasy, Adventure',
        'deskripsi':
            'Seorang pemuda yang bisa mengendalikan mimpi orang lain terjebak dalam konspirasi besar. Ia harus menghadapi musuh dari dunia mimpi yang mencoba menguasai dunia nyata.'
      }
    ];

    final CollectionReference moviesRef =
        FirebaseFirestore.instance.collection('film');

    for (var movie in movies) {
      final QuerySnapshot existingMovies =
          await moviesRef.where('title', isEqualTo: movie['title']).get();

      if (existingMovies.docs.isEmpty) {
        await moviesRef.add(movie);
        print("Added: ${movie['title']}");
      } else {
        print("Movie already exists: ${movie['title']}");
      }
    }
  }
}
