USE [[DBMS]]Tramyte_Demo]
GO
/****** Object:  UserDefinedFunction [dbo].[f_CacThuocTrong1HoaDon]    Script Date: 11/17/2016 9:47:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_CacThuocTrong1HoaDon](@MaHoaDon int)
returns @reTable table (TenThuoc nvarchar(50) not null,SoLuong int not null,TenDonVi nvarchar(50) not null,CachDung nvarchar(50))
as
begin

	insert into @reTable 
		select TenThuoc,SoLuong,DonViTinh.TenDVT,CachDung
		from ChiTietHoaDon,Thuoc,DonViTinh
		where ChiTietHoaDon.MaHoaDon=@MaHoaDon and ChiTietHoaDon.MaThuoc=Thuoc.MaThuoc and ChiTietHoaDon.MaDonVi=DonViTinh.MaDVT

	return;
end

GO
/****** Object:  UserDefinedFunction [dbo].[f_getMaNV_TheoLogin]    Script Date: 11/17/2016 9:47:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_getMaNV_TheoLogin](@username nvarchar(45))
returns nvarchar(45)
as
	begin
			declare @MaNv nvarchar(45)
			select @MaNv=TaiKhoan.MaNV from TaiKhoan where TaiKhoan.username=@username
			return @MaNv
	end
GO
/****** Object:  UserDefinedFunction [dbo].[f_LayGiaTienTheoMaThuoc]    Script Date: 11/17/2016 9:47:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_LayGiaTienTheoMaThuoc](@maThuoc int)
returns  float
as begin 
declare @giaTien float 
set @giaTien=0
select @giaTien= ChiTietThuoc.GiaBanLe 
	from ChiTietThuoc
	where ChiTietThuoc.MaThuoc=@maThuoc
	return @giaTien
end
GO
/****** Object:  UserDefinedFunction [dbo].[f_LichTaiKhamMoiNhat]    Script Date: 11/17/2016 9:47:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[f_LichTaiKhamMoiNhat](@MaKH int)
returns @rtnTable Table(MaHoaDon int not null, NgayTaiKham date not null, GhiChu nvarchar(100) not null)
as
begin
	

		insert into @rtnTable 
		select ltk.MaHoaDon,ltk.NgayTaiKham,ltk.GhiChu
		from LichTaiKham ltk
		where ltk.MaHoaDon = (
										select TOP 1 MaHoaDon 
										from HoaDon 
										where HoaDon.MaKhachHang=@MaKH
										order by HoaDOn.MaHoaDon desc ) and DATEDIFF(day,NgayTaiKham,getdate())>0
	return;		
end

----
--select *
--from [dbo].[f_LichTaiKhamMoiNhat](1)
-----------------------------------------------------------------------------------
/*Table ChiTietHoaDon*/
/*
	Trigger:2
	Sp:3
	Function:1 (hàm trả về bảng)
*/

GO
/****** Object:  UserDefinedFunction [dbo].[f_TaoHD]    Script Date: 11/17/2016 9:47:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_TaoHD] ()
returns int
as
begin
	declare @maHD int
	select top 1 @maHD=MaHoaDon
	from HoaDon
	order by MaHoaDon desc

	return @maHD
end
GO
/****** Object:  UserDefinedFunction [dbo].[f_tongSoTaiKhamTrongNgay]    Script Date: 11/17/2016 9:47:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[f_tongSoTaiKhamTrongNgay] (@NgayTaiKham date)
returns int
as
begin
	declare @t int
	select @t=sum(MaLichHen)
	from LichTaiKham
	where @NgayTaiKham = GETDATE()
	return @t;
end
GO
/****** Object:  UserDefinedFunction [dbo].[f_TongTienBenhNhan]    Script Date: 11/17/2016 9:47:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_TongTienBenhNhan](@MaKH int)
returns float
as
begin
	declare @total float
	select @total= sum(HoaDon.SoTien)
	from HoaDon
	where HoaDon.MaKhachHang=@MaKH
	group by MaKhachHang
	return @total
end

GO
/****** Object:  UserDefinedFunction [dbo].[f_tongTienHoaDon]    Script Date: 11/17/2016 9:47:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[f_tongTienHoaDon] (@MaHoaDon int)
returns float
as
begin
	declare @gt float
	select @gt=sum(ChiTietThuoc.GiaBanLe*ChiTietHoaDon.SoLuong)
	from ChiTietHoaDon,ChiTietThuoc
	where ChiTietHoaDon.MaThuoc=ChiTietThuoc.MaThuoc
	group by ChiTietHoaDon.MaHoaDon
	having ChiTietHoaDon.MaHoaDon=@MaHoaDon
	return @gt
end
GO
/****** Object:  UserDefinedFunction [dbo].[f_TongTienHoaDonTheoNgay]    Script Date: 11/17/2016 9:47:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_TongTienHoaDonTheoNgay](@ngay date)
returns float
as
begin
	declare @r float

	select @r=sum(HoaDon.SoTien) from HoaDon where HoaDon.NgayLapHoaDon=@ngay
		
	return @r
end
GO
/****** Object:  Table [dbo].[BenhNhan]    Script Date: 11/17/2016 9:47:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BenhNhan](
	[MaKH] [int] NOT NULL,
	[TenKhachHang] [nvarchar](50) NULL,
	[QueQuan] [nvarchar](50) NULL,
	[CMND] [nvarchar](50) NULL,
	[NgaySinh] [date] NULL,
	[SDT] [nvarchar](50) NULL,
	[GioiTinh] [nvarchar](50) NULL,
 CONSTRAINT [PK_KhachHang] PRIMARY KEY CLUSTERED 
(
	[MaKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ChiTietHoaDon]    Script Date: 11/17/2016 9:47:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietHoaDon](
	[MaHoaDon] [int] NOT NULL,
	[MaThuoc] [int] NOT NULL,
	[SoLuong] [int] NULL,
	[CachDung] [nvarchar](50) NULL,
	[MaDonVi] [int] NULL,
 CONSTRAINT [PK_ChiTietHoaDon] PRIMARY KEY CLUSTERED 
(
	[MaHoaDon] ASC,
	[MaThuoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ChiTietThuoc]    Script Date: 11/17/2016 9:47:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietThuoc](
	[MaThuoc] [int] NOT NULL,
	[GiaBanLe] [float] NULL,
	[MaDVT_le] [int] NULL,
 CONSTRAINT [PK_ChiTietThuoc] PRIMARY KEY CLUSTERED 
(
	[MaThuoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DonViTinh]    Script Date: 11/17/2016 9:47:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DonViTinh](
	[MaDVT] [int] NOT NULL,
	[TenDVT] [nvarchar](50) NULL,
 CONSTRAINT [PK_DonViTinh] PRIMARY KEY CLUSTERED 
(
	[MaDVT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HoaDon]    Script Date: 11/17/2016 9:47:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoaDon](
	[MaHoaDon] [int] NOT NULL,
	[SoTien] [float] NULL,
	[MaLichHen] [int] NULL,
	[MaKhachHang] [int] NULL,
	[CoBaoHiem] [bit] NULL,
	[MaNV] [int] NULL,
	[NgayLapHoaDon] [date] NULL,
 CONSTRAINT [PK_HoaDon] PRIMARY KEY CLUSTERED 
(
	[MaHoaDon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LichTaiKham]    Script Date: 11/17/2016 9:47:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LichTaiKham](
	[MaLichHen] [int] NOT NULL,
	[MaHoaDon] [int] NULL,
	[NgayTaiKham] [date] NULL,
	[GhiChu] [nvarchar](100) NULL,
 CONSTRAINT [PK_LichTaiKham] PRIMARY KEY CLUSTERED 
(
	[MaLichHen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LichTruc]    Script Date: 11/17/2016 9:47:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LichTruc](
	[MaNV] [int] NOT NULL,
	[NgayDiTruc] [date] NOT NULL,
	[CongViecTruc] [nvarchar](50) NULL,
 CONSTRAINT [PK_ChamCong] PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC,
	[NgayDiTruc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LoaiThuoc]    Script Date: 11/17/2016 9:47:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoaiThuoc](
	[MaLoaiThuoc] [int] NOT NULL,
	[TenLoaiThuoc] [nvarchar](50) NULL,
 CONSTRAINT [PK_LoaiThuoc] PRIMARY KEY CLUSTERED 
(
	[MaLoaiThuoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NhanVien]    Script Date: 11/17/2016 9:47:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhanVien](
	[MaNV] [int] NOT NULL,
	[HoTen] [nvarchar](50) NULL,
	[NgaySinh] [date] NULL,
	[QueQuan] [nvarchar](50) NULL,
	[TrinhDo] [nvarchar](50) NULL,
	[Luong] [float] NULL,
	[ChucVu] [nvarchar](50) NULL,
	[Phai] [nchar](3) NULL,
 CONSTRAINT [PK_NhanVien] PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TaiKhoan]    Script Date: 11/17/2016 9:47:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaiKhoan](
	[username] [nvarchar](50) NOT NULL,
	[password] [nvarchar](50) NULL,
	[MaNV] [int] NULL,
 CONSTRAINT [PK_TaiKhoan] PRIMARY KEY CLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Thuoc]    Script Date: 11/17/2016 9:47:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Thuoc](
	[MaThuoc] [int] NOT NULL,
	[TenThuoc] [nvarchar](50) NULL,
	[MaLoaiThuoc] [int] NULL,
	[MoTa] [nvarchar](100) NULL,
	[TinhTrang] [nvarchar](50) NULL,
 CONSTRAINT [PK_Thuoc] PRIMARY KEY CLUSTERED 
(
	[MaThuoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  UserDefinedFunction [dbo].[f_LayDVTTheoMaThuoc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_LayDVTTheoMaThuoc] (@maThuoc int)
returns table
as
return(
	select DonViTinh.MaDVT,DonViTinh.TenDVT
	from ChiTietThuoc, DonViTinh
	where ChiTietThuoc.MaDVT_le=DonViTinh.MaDVT and ChiTietThuoc.MaThuoc=@maThuoc
)
GO
/****** Object:  UserDefinedFunction [dbo].[f_LichTruc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[f_LichTruc] (@ngay date)
returns table
as
 return( select NhanVien.MaNV,NhanVien.HoTen
			from LichTruc,NhanVien
			where @ngay=GETDATE() and NhanVien.MaNV=LichTruc.MaNV)

GO
/****** Object:  UserDefinedFunction [dbo].[f_showBenhNhan]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[f_showBenhNhan]()
returns table

	return (select * from BenhNhan);
GO
/****** Object:  UserDefinedFunction [dbo].[f_showChiTietThuoc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[f_showChiTietThuoc]()
returns table

	return (select ChiTietThuoc.MaThuoc,Thuoc.TenThuoc,DonViTinh.TenDVT,ChiTietThuoc.GiaBanLe from ChiTietThuoc,DonViTinh,Thuoc where Thuoc.MaThuoc=ChiTietThuoc.MaThuoc and ChiTietThuoc.MaDVT_le=DonViTinh.MaDVT);
GO
/****** Object:  UserDefinedFunction [dbo].[f_showCTHD]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[f_showCTHD](@MaHD int)
returns table
as
	return (select ChiTietHoaDon.MaHoaDon,ChiTietHoaDon.MaThuoc,THuoc.TenThuoc,ChiTietHoaDon.SoLuong,
	ChiTietThuoc.GiaBanLe from ChiTietHoaDon,Thuoc,DonViTinh,ChiTietThuoc where ChiTietHoaDon.MaHoaDon=@MaHD 
	and Thuoc.MaThuoc=ChiTietHoaDon.MaThuoc and ChiTietHoaDon.MaDonVi=DonViTinh.MaDVT and 
	THuoc.MaThuoc=ChiTietThuoc.MaThuoc)
GO
/****** Object:  UserDefinedFunction [dbo].[f_showDVT]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_showDVT]()
returns table
as
	return (select * from DonViTinh)
GO
/****** Object:  UserDefinedFunction [dbo].[f_showHD]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[f_showHD]()
returns table
as 
	return (select HoaDon.MaHoaDon,HoaDon.SoTien,HoaDon.CoBaoHiem,NhanVien.HoTen, HoaDon.NgayLapHoaDon from HoaDon,NhanVien 
	where HoaDon.MaNV=NhanVien.MaNV)
GO
/****** Object:  UserDefinedFunction [dbo].[f_showHoaDonTheoNgay]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[f_showHoaDonTheoNgay](@ngay date)
returns table
as
	return (select HoaDon.MaHoaDon,HoaDon.SoTien,HoaDon.CoBaoHiem,NhanVien.HoTen,NgayLapHoaDon from HoaDon,NhanVien where HoaDon.NgayLapHoaDon=@ngay and HoaDon.MaNV=NhanVien.MaNV)
GO
/****** Object:  UserDefinedFunction [dbo].[f_showLichTaiKham]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_showLichTaiKham]()
returns table
as
	return (select * from LichTaiKham)
GO
/****** Object:  UserDefinedFunction [dbo].[f_showLichTruc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

		create function [dbo].[f_showLichTruc](@manv int)
		returns table
		as
			return (select * from LichTruc where MaNV=@manv)
GO
/****** Object:  UserDefinedFunction [dbo].[f_showLichTrucTheoThoiGian]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	create function [dbo].[f_showLichTrucTheoThoiGian](@manv int, @ngaytruc date)
		returns table
		as
			return (select * from LichTruc where MaNV=@manv and NgayDiTruc=@ngaytruc)
GO
/****** Object:  UserDefinedFunction [dbo].[f_showLoaiThuoc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_showLoaiThuoc]()
returns table
as
	return (select * from LoaiThuoc)
GO
/****** Object:  UserDefinedFunction [dbo].[f_showNhanVien]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	create function [dbo].[f_showNhanVien]()
returns table
as
	return (select * from NhanVien)

GO
/****** Object:  UserDefinedFunction [dbo].[f_showNhanVienTheoMa]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_showNhanVienTheoMa](@MaNV int)
returns table
	as
		return (select * from NhanVien where MaNV=@MaNV)
GO
/****** Object:  UserDefinedFunction [dbo].[f_showThuoc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[f_showThuoc]()
returns table
as
	return (select TenLoaiThuoc,Thuoc.*
	from Thuoc,LoaiThuoc
	where Thuoc.MaLoaiThuoc=LoaiThuoc.MaLoaiThuoc)
	
GO
/****** Object:  UserDefinedFunction [dbo].[f_showThuocTheoMaLoaiThuoc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_showThuocTheoMaLoaiThuoc](@MaLoaiThuoc nvarchar(50))
returns table 
as
	return (select * from Thuoc where Thuoc.MaLoaiThuoc=@MaLoaiThuoc)
GO
/****** Object:  UserDefinedFunction [dbo].[f_taiKham]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[f_taiKham] (@thang date)
returns table
as
	return ( select BenhNhan.TenKhachHang, BenhNhan.MaKH, HoaDon.CoBaoHiem
		from BenhNhan, LichTaiKham, HoaDon
		where BenhNhan.MaKH=HoaDon.MaKhachHang 
		and HoaDon.MaLichHen=LichTaiKham.MaLichHen and LichTaiKham.NgayTaiKham= @thang)

GO
/****** Object:  UserDefinedFunction [dbo].[f_ThongTinBenhNhan]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_ThongTinBenhNhan]
(@MaKH int)
returns table
as
	return (select * from BenhNhan where BenhNhan.MaKH=@MaKH);

GO
/****** Object:  UserDefinedFunction [dbo].[f_thuoc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[f_thuoc] (@MaLoaiThuoc int)
returns table
as
	return (select *
			from Thuoc
			where MaLoaiThuoc=@MaLoaiThuoc)

GO
/****** Object:  UserDefinedFunction [dbo].[f_tinhDoanhThu]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[f_tinhDoanhThu](@ngayBD date, @ngayKT date)
returns table
as
return(
select NgayLapHoaDon,SoTien
from HoaDon
where HoaDon.NgayLapHoaDon>= @ngayBD and HoaDon.NgayLapHoaDon <=@ngayKT)
GO
INSERT [dbo].[BenhNhan] ([MaKH], [TenKhachHang], [QueQuan], [CMND], [NgaySinh], [SDT], [GioiTinh]) VALUES (1, N'd123456789', N'213qqq', N'123456789', CAST(N'2016-11-01' AS Date), N'123456798', N'Nam')
INSERT [dbo].[BenhNhan] ([MaKH], [TenKhachHang], [QueQuan], [CMND], [NgaySinh], [SDT], [GioiTinh]) VALUES (2, N'tennb', N'quenquan', N'123456888', CAST(N'2016-09-09' AS Date), N'123456789', N'Nam')
INSERT [dbo].[BenhNhan] ([MaKH], [TenKhachHang], [QueQuan], [CMND], [NgaySinh], [SDT], [GioiTinh]) VALUES (3, N'eeeeeee', N'eeeeeeeeee', N'123345776', CAST(N'2016-11-09' AS Date), N'123455666', N'Nam')
INSERT [dbo].[BenhNhan] ([MaKH], [TenKhachHang], [QueQuan], [CMND], [NgaySinh], [SDT], [GioiTinh]) VALUES (4, N'123213213', N'321321312321', N'321321312', CAST(N'2016-10-31' AS Date), N'2342432432', N'Nữ')
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [CachDung], [MaDonVi]) VALUES (3, 1, 6, N'cachdung', 1)
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [CachDung], [MaDonVi]) VALUES (6, 1, 7, N'tinhtrang', 1)
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [CachDung], [MaDonVi]) VALUES (7, 1, 7, N'tinhtrang', 1)
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [CachDung], [MaDonVi]) VALUES (8, 1, 3, N'tinhtrang', 1)
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [CachDung], [MaDonVi]) VALUES (8, 9, 3, N'tinhtrang', 1)
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [CachDung], [MaDonVi]) VALUES (9, 1, 7, N'tinhtrang', 1)
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [CachDung], [MaDonVi]) VALUES (9, 9, 3, N'tinhtrang', 1)
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [CachDung], [MaDonVi]) VALUES (10, 9, 7, N'tinhtrang', 1)
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [CachDung], [MaDonVi]) VALUES (12, 1, 7, N'tinhtrang', 1)
INSERT [dbo].[ChiTietHoaDon] ([MaHoaDon], [MaThuoc], [SoLuong], [CachDung], [MaDonVi]) VALUES (12, 9, 7, N'tinhtrang', 1)
INSERT [dbo].[ChiTietThuoc] ([MaThuoc], [GiaBanLe], [MaDVT_le]) VALUES (1, 50000, 1)
INSERT [dbo].[ChiTietThuoc] ([MaThuoc], [GiaBanLe], [MaDVT_le]) VALUES (9, 0, 1)
INSERT [dbo].[DonViTinh] ([MaDVT], [TenDVT]) VALUES (2, N'lọ')
INSERT [dbo].[DonViTinh] ([MaDVT], [TenDVT]) VALUES (1, N'viên')
INSERT [dbo].[HoaDon] ([MaHoaDon], [SoTien], [MaLichHen], [MaKhachHang], [CoBaoHiem], [MaNV], [NgayLapHoaDon]) VALUES (1, NULL, 1, 1, 1, 1, CAST(N'2016-10-10' AS Date))
INSERT [dbo].[HoaDon] ([MaHoaDon], [SoTien], [MaLichHen], [MaKhachHang], [CoBaoHiem], [MaNV], [NgayLapHoaDon]) VALUES (2, 20000, 1, 1, 1, 1, CAST(N'2016-09-10' AS Date))
INSERT [dbo].[HoaDon] ([MaHoaDon], [SoTien], [MaLichHen], [MaKhachHang], [CoBaoHiem], [MaNV], [NgayLapHoaDon]) VALUES (3, 300000, NULL, 1, 0, 1, CAST(N'2016-11-17' AS Date))
INSERT [dbo].[HoaDon] ([MaHoaDon], [SoTien], [MaLichHen], [MaKhachHang], [CoBaoHiem], [MaNV], [NgayLapHoaDon]) VALUES (4, 0, NULL, 1, 0, 1, CAST(N'2016-11-17' AS Date))
INSERT [dbo].[HoaDon] ([MaHoaDon], [SoTien], [MaLichHen], [MaKhachHang], [CoBaoHiem], [MaNV], [NgayLapHoaDon]) VALUES (5, 0, NULL, 1, 0, 1, CAST(N'2016-11-17' AS Date))
INSERT [dbo].[HoaDon] ([MaHoaDon], [SoTien], [MaLichHen], [MaKhachHang], [CoBaoHiem], [MaNV], [NgayLapHoaDon]) VALUES (6, 350000, NULL, 1, 0, 1, CAST(N'2016-11-17' AS Date))
INSERT [dbo].[HoaDon] ([MaHoaDon], [SoTien], [MaLichHen], [MaKhachHang], [CoBaoHiem], [MaNV], [NgayLapHoaDon]) VALUES (7, 350000, NULL, 1, 0, 1, CAST(N'2016-11-17' AS Date))
INSERT [dbo].[HoaDon] ([MaHoaDon], [SoTien], [MaLichHen], [MaKhachHang], [CoBaoHiem], [MaNV], [NgayLapHoaDon]) VALUES (8, 150000, NULL, 1, 0, 1, CAST(N'2016-11-17' AS Date))
INSERT [dbo].[HoaDon] ([MaHoaDon], [SoTien], [MaLichHen], [MaKhachHang], [CoBaoHiem], [MaNV], [NgayLapHoaDon]) VALUES (9, 350000, NULL, 1, 0, 1, CAST(N'2016-11-17' AS Date))
INSERT [dbo].[HoaDon] ([MaHoaDon], [SoTien], [MaLichHen], [MaKhachHang], [CoBaoHiem], [MaNV], [NgayLapHoaDon]) VALUES (10, 0, NULL, 1, 0, 1, CAST(N'2016-11-17' AS Date))
INSERT [dbo].[HoaDon] ([MaHoaDon], [SoTien], [MaLichHen], [MaKhachHang], [CoBaoHiem], [MaNV], [NgayLapHoaDon]) VALUES (11, NULL, NULL, 1, 0, 1, CAST(N'2016-11-17' AS Date))
INSERT [dbo].[HoaDon] ([MaHoaDon], [SoTien], [MaLichHen], [MaKhachHang], [CoBaoHiem], [MaNV], [NgayLapHoaDon]) VALUES (12, 350000, NULL, 1, 0, 1, CAST(N'2016-11-17' AS Date))
INSERT [dbo].[LichTruc] ([MaNV], [NgayDiTruc], [CongViecTruc]) VALUES (1, CAST(N'2016-10-15' AS Date), N'Congviectruc')
INSERT [dbo].[LoaiThuoc] ([MaLoaiThuoc], [TenLoaiThuoc]) VALUES (1, N'loại 1')
INSERT [dbo].[LoaiThuoc] ([MaLoaiThuoc], [TenLoaiThuoc]) VALUES (2, N'loại 2')
INSERT [dbo].[NhanVien] ([MaNV], [HoTen], [NgaySinh], [QueQuan], [TrinhDo], [Luong], [ChucVu], [Phai]) VALUES (1, N'hoten1', CAST(N'1996-09-28' AS Date), N'Bến tre', N'Cao Đẳng', 9000, N'Trạm trưởng', N'Nam')
INSERT [dbo].[NhanVien] ([MaNV], [HoTen], [NgaySinh], [QueQuan], [TrinhDo], [Luong], [ChucVu], [Phai]) VALUES (2, N'hoten_new', CAST(N'2016-10-10' AS Date), N'queuqna_new', N'Ð?i h?c', 900000, N'Bác sĩ', N'Nữ ')
INSERT [dbo].[TaiKhoan] ([username], [password], [MaNV]) VALUES (N'bs2', N'1234', 2)
INSERT [dbo].[TaiKhoan] ([username], [password], [MaNV]) VALUES (N'bs8', N'1234', 8)
INSERT [dbo].[TaiKhoan] ([username], [password], [MaNV]) VALUES (N'trtram', N'1234', 1)
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [MaLoaiThuoc], [MoTa], [TinhTrang]) VALUES (1, N'tenthuoc1', 1, N'tinhtrang', N'mota')
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [MaLoaiThuoc], [MoTa], [TinhTrang]) VALUES (5, N'tenthuoc2', 1, N'trinh trang', N'mota')
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [MaLoaiThuoc], [MoTa], [TinhTrang]) VALUES (6, N'tenthuoc3', 1, N'trinh trang', N'mota')
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [MaLoaiThuoc], [MoTa], [TinhTrang]) VALUES (7, N'tenthuoc4', 1, N'trinh trang', N'mota')
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [MaLoaiThuoc], [MoTa], [TinhTrang]) VALUES (8, N'tenthuoc5', 1, N'trinh trang', N'mota')
INSERT [dbo].[Thuoc] ([MaThuoc], [TenThuoc], [MaLoaiThuoc], [MoTa], [TinhTrang]) VALUES (9, N'tenthuoc6', 2, N'tinhtrang', N'mota')
ALTER TABLE [dbo].[ChiTietHoaDon]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietHoaDon_HoaDon] FOREIGN KEY([MaHoaDon])
REFERENCES [dbo].[HoaDon] ([MaHoaDon])
GO
ALTER TABLE [dbo].[ChiTietHoaDon] CHECK CONSTRAINT [FK_ChiTietHoaDon_HoaDon]
GO
ALTER TABLE [dbo].[ChiTietHoaDon]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietHoaDon_Thuoc] FOREIGN KEY([MaThuoc])
REFERENCES [dbo].[Thuoc] ([MaThuoc])
GO
ALTER TABLE [dbo].[ChiTietHoaDon] CHECK CONSTRAINT [FK_ChiTietHoaDon_Thuoc]
GO
ALTER TABLE [dbo].[ChiTietThuoc]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietThuoc_DonViTinh1] FOREIGN KEY([MaDVT_le])
REFERENCES [dbo].[DonViTinh] ([MaDVT])
GO
ALTER TABLE [dbo].[ChiTietThuoc] CHECK CONSTRAINT [FK_ChiTietThuoc_DonViTinh1]
GO
ALTER TABLE [dbo].[ChiTietThuoc]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietThuoc_Thuoc] FOREIGN KEY([MaThuoc])
REFERENCES [dbo].[Thuoc] ([MaThuoc])
GO
ALTER TABLE [dbo].[ChiTietThuoc] CHECK CONSTRAINT [FK_ChiTietThuoc_Thuoc]
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD  CONSTRAINT [FK_HoaDon_NhanVien] FOREIGN KEY([MaNV])
REFERENCES [dbo].[NhanVien] ([MaNV])
GO
ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [FK_HoaDon_NhanVien]
GO
ALTER TABLE [dbo].[LichTruc]  WITH CHECK ADD  CONSTRAINT [FK_LichTruc_NhanVien] FOREIGN KEY([MaNV])
REFERENCES [dbo].[NhanVien] ([MaNV])
GO
ALTER TABLE [dbo].[LichTruc] CHECK CONSTRAINT [FK_LichTruc_NhanVien]
GO
/****** Object:  StoredProcedure [dbo].[sp_Backup_Database]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Backup_Database] 
-- Add the parameters for the stored procedure here
 
@Location nvarchar(255)   
 
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
 
SET NOCOUNT ON;

Declare @DBFileName nvarchar(255)
 
Set @DBFileName ='[[DBMS]]Tramyte_Demo].bak';
 
Select @DBFileName
 

EXEC ('BACKUP DATABASE '+ '[[DBMS]]Tramyte_Demo]' +' TO  DISK = N'''+ @Location + 
        @DBFileName +''' WITH COPY_ONLY,  NAME = N'''+ '[[DBMS]]Tramyte_Demo]' +'-Full Database Backup''')
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Restore_Database]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sp_Restore_Database](@path nvarchar(100))
as
	begin
		exec('	use master 
			alter database [[DBMS]]Tramyte_Demo]
			set single_user
			 with rollback immediate
			  restore database [[DBMS]]Tramyte_Demo] from disk='+@path+'')
		
	end
GO
/****** Object:  StoredProcedure [dbo].[spCapNhatBenhNhan]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spCapNhatBenhNhan]
	@MaKH int,
	@TenKhachHang nvarchar(50),
	@QueQuan nvarchar(50),
	@CMND	nvarchar(50),
	@NgaySinh nvarchar(50),
	@SDT nvarchar(50),
	@GioiTinh nvarchar(50)
as
begin

	if not exists(select * from BenhNhan where MaKH=@MaKH)
		begin
			print N'Không tồn tại Bệnh nhân với mã '+ cast(@MaKH as nvarchar(1))
			return;
		end

		if(Len(@TenKhachHang)=0 )
			begin
				print N'Tên Khách Hàng không được bỏ trống'
				return;
			end
		update BenhNhan
		set TenKhachHang=@TenKhachHang,
			QueQuan=@QueQuan,
			CMND=@CMND,
			NgaySinh=@NgaySinh,
			SDT=@SDT,
			@GioiTinh=@GioiTinh
		where BenhNhan.MaKH=@MaKH
end

GO
/****** Object:  StoredProcedure [dbo].[spCapNhatChiTietHoaDon]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[spCapNhatChiTietHoaDon]
	@MaHoaDon int,
	@MaThuoc int,
	@SoLuong int,
	@CachDung nvarchar(50),
	@MaDonVi int
as
begin
	update ChiTietHoaDon 
	set SoLuong=@SoLuong,CachDung=@CachDung,MaDonVi=@MaDonVi
	where MaHoaDon=@MaHoaDon and MaThuoc=@MaThuoc
end

GO
/****** Object:  StoredProcedure [dbo].[spCapNhatChiTietThuoc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCapNhatChiTietThuoc]
	@MaThuoc int,
	@GiaBanLe nvarchar(50),
	@MaDVT_le int
as
begin
	update ChiTietThuoc set GiaBanLe=@GiaBanLe, MaDVT_le=@MaDVT_le where ChiTietThuoc.MaThuoc=@MaThuoc
end

GO
/****** Object:  StoredProcedure [dbo].[spCapNhatDVT]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCapNhatDVT]
	@MaDVT int,
	@TenDVT nvarchar(50)
as
begin
	update DonViTinh set TenDVT=@TenDVT where MaDVT=@MaDVT
end
GO
/****** Object:  StoredProcedure [dbo].[spCapNhatLichTaiKham]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCapNhatLichTaiKham]
	@MaHoaDon int,
	@MaLichHen int,
	@NgayTaiKham date
as
begin
	update LichTaiKham set NgayTaiKham=@NgayTaiKham, MaHoaDon=@MaHoaDon where MaLichHen=@MaLichHen
end
GO
/****** Object:  StoredProcedure [dbo].[spCapNhatLichTruc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- cap nhat lich truc
create proc [dbo].[spCapNhatLichTruc]
	@MaNV int,
	@NgayDiTuc date,
	@CongViecTruc nvarchar(50)
as
begin
	update LichTruc set NgayDiTruc=@NgayDiTuc, CongViecTruc=@CongViecTruc where MaNV=@MaNV
end
GO
/****** Object:  StoredProcedure [dbo].[spCapNhatLoaiThuoc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCapNhatLoaiThuoc]
	@MaLT int,
	@TenLThuoc nvarchar(50)
as
begin
	update LoaiThuoc set TenLoaiThuoc=@TenLThuoc where MaLoaiThuoc=@MaLT
end
GO
/****** Object:  StoredProcedure [dbo].[spCapNhatNhanVien]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCapNhatNhanVien]
	@MaNV int,
	@Hoten nvarchar(50),
	@NgaySinh date,
	@QueQuan nvarchar(50),
	@TrinhDo nvarchar(50),
	@Luong float,
	@ChucVu nvarchar(50),
	@Phai nvarchar(3)
as
begin
	update NhanVien set HoTen=@Hoten,NgaySinh=@NgaySinh,QueQuan=@QueQuan,
						TrinhDo=@TrinhDo,Luong=@Luong,ChucVu=@ChucVu,Phai=@Phai where MaNV=@MaNV
end
GO
/****** Object:  StoredProcedure [dbo].[spCapNhatThuoc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCapNhatThuoc]
	@MaT int,
	@TenThuoc nvarchar(50),
	@MaLT int,
	@TinhTrang nvarchar(50),
	@Mota nvarchar(100)
as
begin
	update Thuoc set TenThuoc=@TenThuoc, MaLoaiThuoc=@MaLT,
						TinhTrang=@TinhTrang,MoTa=@Mota where MaThuoc=@MaT
end
GO
/****** Object:  StoredProcedure [dbo].[spThemBenhNhan]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[spThemBenhNhan]
	@TenKhachHang nvarchar(50),
	@QueQuan nvarchar(50),
	@CMND nvarchar(50),
	@NgaySinh date,
	@SDT nvarchar(50),
	@GioiTinh nvarchar(50)
as
begin
	
	declare @i int
	set @i=1;
	declare @MaKH int

	declare curMaKH
	cursor for select MaKH from BenhNhan
	open curMaKH
	fetch next from curMaKH
	into @MaKH

	while(@@FETCH_STATUS=0)
		begin
			if(@i=@MaKH)
				begin
					set @i=@i+1
					fetch next from curMaKH
					into @MaKH
					continue
				end;
			else 
			break
		end

	close curMaKH
	deallocate curMaKH

	insert into BenhNhan values(@i,@TenKhachHang,@QueQuan,@CMND,@NgaySinh,@SDT,@GioiTinh)
end

GO
/****** Object:  StoredProcedure [dbo].[spThemChiTietHoaDon]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[spThemChiTietHoaDon]
	@MaHoaDon int,
	@MaThuoc int,
	@SoLuong int,
	@CachDung nvarchar(50),
	@MaDonVi int
as
begin
	insert into ChiTietHoaDon values(@MaHoaDon,@MaThuoc,@SoLuong,@CachDung,@MaDonVi)
end

GO
/****** Object:  StoredProcedure [dbo].[spThemChiTietThuoc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[spThemChiTietThuoc]
	@MaThuoc int,
	@GiaBanLe float,
	@MaDVT_le int
as
begin
	if(@GiaBanLe<0)
		return;
	insert into ChiTietThuoc values(@MaThuoc,@GiaBanLe,@MaDVT_le);
end

GO
/****** Object:  StoredProcedure [dbo].[spThemDVT]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[spThemDVT]
	@TenDVT nvarchar(50)
as
begin
	
	declare @i int
	set @i=1;
	declare @MaDVT int

	declare curMaDVT
	cursor for select MaDVT from DonViTinh
	open curMaDVT
	fetch next from curMaDVT
	into @MaDVT

	while(@@FETCH_STATUS=0)
		begin
			if(@i=@MaDVT)
				begin
					set @i=@i+1
					fetch next from curMaDVT
					into @MaDVT
					continue
				end;
			else 
			break
		end

	close curMaDVT
	deallocate curMaDVT

	insert into DonViTinh values(@i,@TenDVT)
end
GO
/****** Object:  StoredProcedure [dbo].[spThemHoaDon]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[spThemHoaDon]
	@SoTien float,
	@MaKhachHang int,
	@CoBaoHiem bit,
	@MaNV int,
	@NgayLapHoaDon date
as
begin
	declare @i int
	set @i=1;
	declare @MaHoaDon int

	declare curMaHoaDon
	cursor for select MaHoaDon from HoaDon
	open curMaHoaDon
	fetch next from curMaHoaDon
	into @MaHoaDon

	while(@@FETCH_STATUS=0)
		begin
			if(@i=@MaHoaDon)
				begin
					set @i=@i+1
					fetch next from curMaHoaDon
					into @MaHoaDon
					continue
				end;
			else 
				break
		end

	close curMaHoaDon
	deallocate curMaHoaDon

	insert into HoaDon values(@i,@SoTien,null,@MaKhachHang,@CoBaoHiem,@MaNV,@NgayLapHoaDon)
end
GO
/****** Object:  StoredProcedure [dbo].[spThemLichTaiKham]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemLichTaiKham]
	@MaHoaDon int,
	@NgayTaiKham date,
	@GhiChu nvarchar(100)
as
begin
	
	declare @i int
	set @i=1;
	declare @MaLTK int

	declare curMaLTK
	cursor for select @MaLTK from LichTaiKham
	open curMaLTK
	fetch next from curMaLTK
	into @MaLTK

	while(@@FETCH_STATUS=0)
		begin
			if(@i=@MaLTK)
				begin
					set @i=@i+1
					fetch next from curMaLTK
					into @MaLTK
					continue
				end;
			else 
			break
		end

	close curMaLTK
	deallocate curMaLTK

	insert into LichTaiKham values(@i,@MaHoaDon,@NgayTaiKham,@GhiChu)
end
GO
/****** Object:  StoredProcedure [dbo].[spThemLichTruc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemLichTruc]
	@MaNV int,
	@NgayDiTuc date,
	@CongViecTruc nvarchar(50)
as
begin
	insert into LichTruc values(@MaNV,@NgayDiTuc,@CongViecTruc)
end
GO
/****** Object:  StoredProcedure [dbo].[spThemLoaiThuoc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spThemLoaiThuoc]
	@TenLoaiThuoc nvarchar(50)
as
begin
	
	declare @i int
	set @i=1;
	declare @MaLT int

	declare curMaLT
	cursor for select MaLoaiThuoc from LoaiThuoc
	open curMaLT
	fetch next from curMaLT
	into @MaLT

	while(@@FETCH_STATUS=0)
		begin
			if(@i=@MaLT)
				begin
					set @i=@i+1
					fetch next from curMaLT
					into @MaLT
					continue
				end;
			else 
			break
		end

	close curMaLT
	deallocate curMaLT

	insert into LoaiThuoc values(@i,@TenLoaiThuoc)
end
GO
/****** Object:  StoredProcedure [dbo].[spThemNV]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spThemNV]
	@Hoten nvarchar(50),
	@NgaySinh date,
	@QueQuan nvarchar(50),
	@TrinhDo nvarchar(50),
	@Luong float,
	@ChucVu nvarchar(50),
	@Phai nvarchar(3)
as
begin
	
	declare @i int
	set @i=1;
	declare @MaNV int

	declare curMaNV
	cursor for select MaNV from NhanVien
	open curMaNV
	fetch next from curMaNV
	into @MaNV

	while(@@FETCH_STATUS=0)
		begin
			if(@i=@MaNV)
				begin
					set @i=@i+1
					fetch next from curMaNV
					into @MaNV
					continue
				end;
			else 
			break
		end

	close curMaNV
	deallocate curMaNV

	insert into NhanVien values(@i,@Hoten,@NgaySinh,@QueQuan,@TrinhDo,@Luong,@ChucVu,@Phai)

	
	
	--if(@ChucVu=N'Bác sĩ')
	--	begin
	--		declare @username_lg nvarchar(50),@password nvarchar(50), @username_u nvarchar(50)

	--		set @username_lg='bs'+cast(@i as nvarchar(50))
	--		set @username_u='bs'+cast(@i as nvarchar(50))
	--		set @password='1234'

	--		insert into TaiKhoan values(@username_lg,@password,@i);

	--		EXEC sp_addlogin @username_lg, @password;  

	--		EXEC sp_adduser @username_u, @username_lg ;  

	--		exec ('grant select on NhanVien to ' +@username_lg)
			 
	--	end
end
GO
/****** Object:  StoredProcedure [dbo].[spThemThuoc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spThemThuoc]
	@TenThuoc nvarchar(50),
	@MaLT int,
	@TinhTrang nvarchar(50),
	@Mota nvarchar(100)
as
begin
	
	declare @i int
	set @i=1;
	declare @MaT int

	declare curMaT
	cursor for select MaThuoc from Thuoc
	open curMaT
	fetch next from curMaT
	into @MaT

	while(@@FETCH_STATUS=0)
		begin
			if(@i=@MaT)
				begin
					set @i=@i+1
					fetch next from curMaT
					into @MaT
					continue
				end;
			else 
			break
		end

	close curMaT
	deallocate curMaT

	insert into Thuoc values(@i,@TenThuoc,@MaLT,@TinhTrang,	@Mota)
end

GO
/****** Object:  StoredProcedure [dbo].[spXoaBenhNhan]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[spXoaBenhNhan]
	@MaKH int
as
begin
	delete from BenhNhan where BenhNhan.MaKH=@MaKH
end
--

GO
/****** Object:  StoredProcedure [dbo].[spXoaChiTietHoaDon]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[spXoaChiTietHoaDon]
	@MaHoaDon int,
	@MaThuoc int
as
begin
	delete from ChiTietHoaDon where MaHoaDon=@MaHoaDon and MaThuoc=@MaThuoc
end

GO
/****** Object:  StoredProcedure [dbo].[spXoaChiTietThuoc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spXoaChiTietThuoc]
	@MaThuoc int
as
begin
	delete from ChiTietThuoc where MaThuoc=@MaThuoc
end

GO
/****** Object:  StoredProcedure [dbo].[spXoaDVT]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spXoaDVT]
	@MaDVT int
as
begin
	delete from DonViTinh where DonViTinh.MaDVT=@MaDVT
end
GO
/****** Object:  StoredProcedure [dbo].[spXoaHoaDon]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- xoa hoa don
create proc [dbo].[spXoaHoaDon]
	@MaHoaDon int
as
begin

	delete from LichTaiKham where LichTaiKham.MaLichHen in (select MaLichHen from LichTaiKham where MaHoaDon=@MaHoaDon)
	
	delete from HoaDon where MaHoaDon=@MaHoaDon;
end
-- Them lich truc
if(exists(select * From sysobjects where name='spThemLichTruc' and type='P'))
Drop Proc spThemLichTruc

GO
/****** Object:  StoredProcedure [dbo].[spXoaLichTaiKham]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spXoaLichTaiKham]
	@MaLichHen int
as
begin
	delete from LichTaiKham where LichTaiKham.MaLichHen=@MaLichHen
end
GO
/****** Object:  StoredProcedure [dbo].[spXoaLichTruc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- xoa lich truc
create proc [dbo].[spXoaLichTruc]
	@MaNV int
as
begin
	delete from LichTruc where LichTruc.MaNV=@MaNV
end
GO
/****** Object:  StoredProcedure [dbo].[spXoaLoaiThuoc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spXoaLoaiThuoc]
	@MaLT int
as
begin
	delete from LoaiThuoc where LoaiThuoc.MaLoaiThuoc=@MaLT
end
GO
/****** Object:  StoredProcedure [dbo].[spXoaNhanVien]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spXoaNhanVien]
	@MaNV int
as
begin
	delete from NhanVien where NhanVien.MaNV=@MaNV
end
GO
/****** Object:  StoredProcedure [dbo].[spXoaThuoc]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spXoaThuoc]
	@MaT int
as
begin
	delete from Thuoc where Thuoc.MaThuoc=@MaT
end
GO
/****** Object:  Trigger [dbo].[Tg_ThemBN]    Script Date: 11/17/2016 9:47:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE trigger [dbo].[Tg_ThemBN] on [dbo].[BenhNhan]
for insert
as
begin
	declare @TenKhachHang nvarchar(50),@QuenQuan nvarchar(50),@CMND nvarchar(50),@NgaySinh date,@SDT nvarchar(50)

	select @TenKhachHang=i.TenKhachHang,@QuenQuan=i.QueQuan,@CMND=i.CMND,@NgaySinh=i.NgaySinh,@SDT=i.SDT
	from inserted i

	if(Len(@TenKhachHang)=0)
		begin
			print N'Tên Khách Hàng không được bỏ trống'
			rollback
			return;
		end

	if(Len(@CMND)!=0)
		begin
			if(Len(@CMND)<9 or Len(@CMND)>10)
				begin
					print N'CMND có độ dài 9-10 số'
					rollback
					return;
				end
		end

	if ((select count(*) from BenhNhan where CMND=@CMND))>1
		begin
			print @CMND
			print N'Đã tồn tại CMND'
			rollback
			return;
		end
	

	if(@NgaySinh>getdate())
		begin
			print N'Ngày sinh không hợp lệ'
			rollback
			return;
		end
end

GO
ALTER TABLE [dbo].[BenhNhan] ENABLE TRIGGER [Tg_ThemBN]
GO
/****** Object:  Trigger [dbo].[Tg_XoaBN]    Script Date: 11/17/2016 9:47:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[Tg_XoaBN] on [dbo].[BenhNhan]
for delete
as
begin

	declare @MaKH nvarchar(50)

	select @MaKH=deleted.MaKH
	from deleted

	delete from LichTaiKham where LichTaiKham.MaLichHen in (select MaLichHen 
	from HoaDon where HoaDon.MaKhachHang=@MaKH)

	update HoaDon
	set MaKhachHang=null
	where HoaDon.MaKhachHang=@MaKH

end

GO
ALTER TABLE [dbo].[BenhNhan] ENABLE TRIGGER [Tg_XoaBN]
GO
/****** Object:  Trigger [dbo].[Tg_ThemCTHDon]    Script Date: 11/17/2016 9:47:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[Tg_ThemCTHDon] on [dbo].[ChiTietHoaDon]
for insert,update
as
begin
	declare @SoLuong int,@CachDung nvarchar(50)

	select @SoLuong=SoLuong, @CachDung=CachDung
	from inserted 

	if(@SoLuong<0)
		begin
			print N'Số lượng < 0'
			rollback
			return
		end
	if(Len(@CachDung)=0)
		begin
			print N'Chưa có cách dùng'
			rollback
			return
		end
end

GO
ALTER TABLE [dbo].[ChiTietHoaDon] ENABLE TRIGGER [Tg_ThemCTHDon]
GO
/****** Object:  Trigger [dbo].[trigger_CapNhatSoTienHoaDon_Insert_Update]    Script Date: 11/17/2016 9:47:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE trigger [dbo].[trigger_CapNhatSoTienHoaDon_Insert_Update] on [dbo].[ChiTietHoaDon]
after insert, update
as
begin
	declare @MaHD int, @SoTien float
	set @MaHD=(select MaHoaDon from inserted)
	set @SoTien=[dbo].[f_tongTienHoaDon](@MaHD)

	update HoaDon set SoTien=@SoTien where HoaDon.MaHoaDon=@MaHD
end
GO
ALTER TABLE [dbo].[ChiTietHoaDon] ENABLE TRIGGER [trigger_CapNhatSoTienHoaDon_Insert_Update]
GO
/****** Object:  Trigger [dbo].[trigger_CapNhatSoTienHoaDon_KhiXoa]    Script Date: 11/17/2016 9:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[trigger_CapNhatSoTienHoaDon_KhiXoa] on [dbo].[ChiTietHoaDon]
after delete
as
begin
	declare @MaHD int, @SoTien float
	set @MaHD=(select MaHoaDon from deleted)
	set @SoTien=[dbo].[f_tongTienHoaDon](@MaHD)
	
	update HoaDon set SoTien=@SoTien where HoaDon.MaHoaDon=@MaHD
end
GO
ALTER TABLE [dbo].[ChiTietHoaDon] ENABLE TRIGGER [trigger_CapNhatSoTienHoaDon_KhiXoa]
GO
/****** Object:  Trigger [dbo].[Tg_LichTruc]    Script Date: 11/17/2016 9:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Trigger [dbo].[Tg_LichTruc] on [dbo].[LichTruc]
for insert, update
as
begin
	declare @MaNV int, @NgayDiTruc Date, @congViecTruc nvarchar(50)
	--
	--begin
		select @MaNV=i.MaNV, @NgayDiTruc=i.NgayDiTruc, @congViecTruc=i.CongViecTruc
		from inserted i

		if(Len(@MaNV)=0)
			begin
				print N'Ten Nhan Vien khong duoc bo trong'
				rollback
				return;
			end
		if(Len(@NgayDiTruc)=getdate())
			begin
				print N'Ngay dang ki truc khong hop le'
				rollback
				return;
			end
		if(Len(@congViecTruc)=Null)
			begin
				print N'Co the dien them cong viec truc'
				rollback
				return;
			end
		--end
	end

GO
ALTER TABLE [dbo].[LichTruc] ENABLE TRIGGER [Tg_LichTruc]
GO
/****** Object:  Trigger [dbo].[Tg_XoaLoaiThuoc]    Script Date: 11/17/2016 9:47:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE trigger [dbo].[Tg_XoaLoaiThuoc] on [dbo].[LoaiThuoc]
for delete
as
begin
	
	declare @maloaithuoc int

	select @maloaithuoc=MaLoaiThuoc from LoaiThuoc

	delete from Thuoc where Thuoc.MaThuoc in (select MaThuoc from Thuoc where MaLoaiThuoc=@maloaithuoc)


end


GO
ALTER TABLE [dbo].[LoaiThuoc] ENABLE TRIGGER [Tg_XoaLoaiThuoc]
GO
/****** Object:  Trigger [dbo].[Tg_ThemThuoc]    Script Date: 11/17/2016 9:47:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[Tg_ThemThuoc]
on [dbo].[Thuoc]
after insert
as
begin
	declare @mathuoc int

	select @mathuoc=inserted.MaThuoc from inserted 

	insert into ChiTietThuoc values(@mathuoc,'',1);
end
GO
ALTER TABLE [dbo].[Thuoc] ENABLE TRIGGER [Tg_ThemThuoc]
GO
