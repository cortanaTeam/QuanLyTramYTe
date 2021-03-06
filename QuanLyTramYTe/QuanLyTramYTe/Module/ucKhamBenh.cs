﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using bussinessAccessLayer;
using QuanLyTramYTe.Classes;
namespace QuanLyTramYTe.Module
{
    public partial class ucKhamBenh : UserControl
    {
        UserModel um;

        BenhNhanDAO bnDAO;
        ThuocDAO tDAO;
        HoaDonDAO hdDAO;
        ChiTietHoaDonDAO cthdDAO;
        LoaiThuocDAO ltDAO;

        public ucKhamBenh(UserModel um)
        {
            InitializeComponent();

            this.um=um;
            bnDAO=new BenhNhanDAO(um.getDataSource(), um.getUid(), um.getPwd());
            ltDAO=new LoaiThuocDAO(um.getDataSource(), um.getUid(), um.getPwd());
            tDAO=new ThuocDAO(um.getDataSource(), um.getUid(), um.getPwd());
            hdDAO=new HoaDonDAO(um.getDataSource(), um.getUid(), um.getPwd());
            cthdDAO=new ChiTietHoaDonDAO(um.getDataSource(), um.getUid(), um.getPwd());

            cmbBenhNhan.AutoCompleteMode=AutoCompleteMode.SuggestAppend;
            cmbBenhNhan.AutoCompleteSource=AutoCompleteSource.ListItems;

            cmbLoaiThuoc.AutoCompleteMode=AutoCompleteMode.SuggestAppend;
            cmbLoaiThuoc.AutoCompleteSource=AutoCompleteSource.ListItems;

            cmbThuoc.AutoCompleteMode=AutoCompleteMode.SuggestAppend;
            cmbThuoc.AutoCompleteSource=AutoCompleteSource.ListItems;

        }

        private void panel2_Paint(object sender, PaintEventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }
        DataTable dtBN = new DataTable();
        DataTable dtLoaiThuoc = new DataTable();


        string currentMaLoaiThuoc;
        private void LoadData()
        {
            dtBN=bnDAO.getBenhNhan().Tables[0];
            if (dtBN.Rows.Count<=0)
                return;

            cmbBenhNhan.Items.Clear();
            cmbBenhNhan.DataSource=dtBN;
            cmbBenhNhan.DisplayMember="TenKhachHang";
            cmbBenhNhan.ValueMember="MaKH";

            dtLoaiThuoc=ltDAO.getLoaiThuoc().Tables[0];

            cmbLoaiThuoc.Items.Clear();
            cmbLoaiThuoc.DataSource=dtLoaiThuoc;
            cmbLoaiThuoc.ValueMember="MaLoaiThuoc";
            cmbLoaiThuoc.DisplayMember="TenLoaiThuoc";

        }
        private void ucKhamBenh_Load(object sender, EventArgs e)
        {
            this.LoadData();
        }

        private void cmbBenhNhan_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtGT.Text=dtBN.Rows[cmbBenhNhan.SelectedIndex]["GioiTinh"].ToString();
            txtNamSinh.Text=DateTime.Parse(dtBN.Rows[cmbBenhNhan.SelectedIndex]["NgaySinh"].ToString()).ToShortDateString();
            txtQueQuan.Text=dtBN.Rows[cmbBenhNhan.SelectedIndex]["QueQuan"].ToString();
            txtCMND.Text=dtBN.Rows[cmbBenhNhan.SelectedIndex]["CMND"].ToString();
            txtSDT.Text=dtBN.Rows[cmbBenhNhan.SelectedIndex]["SDT"].ToString();
        }

        private void label11_Click(object sender, EventArgs e)
        {

        }

        private void comboBox7_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e)
        {
            this.Hide();
            this.Parent.Controls.Add(new ucBenhNhan(um));
        }
        DataTable dtThuoc;
        private void cmbLoaiThuoc_SelectedIndexChanged(object sender, EventArgs e)
        {
            currentMaLoaiThuoc=cmbLoaiThuoc.SelectedValue.ToString();

            try
            {
                dtThuoc=new DataTable();

                dtThuoc=tDAO.getThuocTheoMaLoaiThuoc(currentMaLoaiThuoc).Tables[0];

                cmbThuoc.DataSource=dtThuoc;
                cmbThuoc.DisplayMember="TenThuoc";
                cmbThuoc.ValueMember="MaThuoc";

            }
            catch { }
        }

        private void cmbThuoc_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                cmbSoLuong.Items.Clear();
                cmbSoLuong.Items.Add("1");
                cmbSoLuong.Items.Add("3");
                cmbSoLuong.Items.Add("5");
                cmbSoLuong.Items.Add("7");
                cmbSoLuong.Items.Add("10");
                txtCachDung.Text=dtThuoc.Rows[cmbThuoc.SelectedIndex]["MoTa"].ToString();
                txtGiaThuoc.Text=tDAO.getGiaThuoc(cmbThuoc.SelectedValue.ToString()).ToString();

                DataTable dtDVT = new DataTable();
                dtDVT=tDAO.getDVT(cmbThuoc.SelectedValue.ToString()).Tables[0];

                cmbDVT.DataSource=dtDVT;
                cmbDVT.DisplayMember="TenDVT";
                cmbDVT.ValueMember="MaDVT";
            }
            catch { }
        }

        private void btnCong_Click(object sender, EventArgs e)
        {
            string currHD = txtMaHD.Text;
            string mathuoc = cmbThuoc.SelectedValue.ToString();
            string tenthuoc = cmbThuoc.Text;
            int sl = int.Parse(cmbSoLuong.Text);
            string cachdung = txtCachDung.Text;
            double gtien = double.Parse(txtGiaThuoc.Text);

            bool themCTHD = cthdDAO.ThemChiTietHoaDon(txtMaHD.Text, cmbThuoc.SelectedValue.ToString(), int.Parse(cmbSoLuong.Text), txtCachDung.Text, int.Parse(cmbDVT.SelectedValue.ToString()));
            if (!themCTHD)
            {
                MessageBox.Show("Lỗi");
                return;
            }
            MessageBox.Show("ok");
            btnTaoHD.Enabled=false;
            dgvToaThuoc.Rows.Add(mathuoc, tenthuoc, sl, cachdung, gtien*sl);
        }

        private void btnTaoHD_Click(object sender, EventArgs e)
        {
            bool themmoihoadon = hdDAO.ThemHoaDon(0, cmbBenhNhan.SelectedValue.ToString(), false, um.getManv(), DateTime.Now);
            if (!themmoihoadon)
            {
                MessageBox.Show("Lỗi");
                return;
            }

            txtMaHD.Enabled=true;
            txtMaHD.Text=hdDAO.getMaHDNew().ToString();
        }

        private void btnTru_Click(object sender, EventArgs e)
        {
            int r = dgvToaThuoc.CurrentCell.RowIndex;
            string currMaThuoc = dgvToaThuoc.Rows[r].Cells["MaThuoc"].Value.ToString();

            bool ktXoa = cthdDAO.XoaChiTietHoaDon(txtMaHD.Text, currMaThuoc);
            if (!ktXoa)
            {
                MessageBox.Show("Lỗi");
                return;
            }
            dgvToaThuoc.Rows.RemoveAt(r);

        }
        //double thanhtien = hdDAO.TongTienHoaDon(txtMaHD.Text);

        //txtThanhTien.Text=thanhtien.ToString();
        //}
    }
}
