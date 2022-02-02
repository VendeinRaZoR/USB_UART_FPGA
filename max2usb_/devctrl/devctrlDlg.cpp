// devctrlDlg.cpp : implementation file
//

#include "stdafx.h"
#include "devctrl.h"
#include "devctrlDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

/////////////////////////////////////////////////////////////////////////////
// CDevctrlDlg dialog

CDevctrlDlg::CDevctrlDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CDevctrlDlg::IDD, pParent)
{
	//{{AFX_DATA_INIT(CDevctrlDlg)
		// NOTE: the ClassWizard will add member initialization here
	//}}AFX_DATA_INIT
	// Note that LoadIcon does not require a subsequent DestroyIcon in Win32
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CDevctrlDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	//{{AFX_DATA_MAP(CDevctrlDlg)
	DDX_Control(pDX, IDC_TREE, m_tree);
	//}}AFX_DATA_MAP
}

BEGIN_MESSAGE_MAP(CDevctrlDlg, CDialog)
	//{{AFX_MSG_MAP(CDevctrlDlg)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON_SCAN, OnButtonScan)
	ON_BN_CLICKED(IDC_CHECK0, OnCheck0)
	ON_BN_CLICKED(IDC_CHECK1, OnCheck1)
	ON_BN_CLICKED(IDC_CHECK2, OnCheck2)
	ON_BN_CLICKED(IDC_CHECK3, OnCheck3)
	ON_BN_CLICKED(IDC_CHECK4, OnCheck4)
	ON_BN_CLICKED(IDC_CHECK5, OnCheck5)
	ON_BN_CLICKED(IDC_CHECK6, OnCheck6)
	ON_BN_CLICKED(IDC_CHECK7, OnCheck7)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// CDevctrlDlg message handlers

BOOL CDevctrlDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	// TODO: Add extra initialization here
	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CDevctrlDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, (WPARAM) dc.GetSafeHdc(), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CDevctrlDlg::OnQueryDragIcon()
{
	return (HCURSOR) m_hIcon;
}

extern "C" VOID EnumerateHostControllers (
    HTREEITEM  hTreeParent,
    ULONG     *DevicesConnected
);

extern "C" HWND ghTreeWnd;
extern "C" ULONG ghHubDevice;

void CDevctrlDlg::OnButtonScan() 
{
	ghTreeWnd = m_tree.m_hWnd;
	ULONG DevCon = 0;
	m_tree.DeleteAllItems();
	HTREEITEM item = m_tree.InsertItem("top");
	EnumerateHostControllers(item,&DevCon);
	Invalidate(TRUE);

	char title[128];
	sprintf(title,"Marsohod USB [%08X]",ghHubDevice);
	SetWindowText(title);
}

extern "C" void WriteWord(USHORT  wr_word);

void CDevctrlDlg::OnCheck0() 
{
	int a0 = IsDlgButtonChecked(IDC_CHECK0);
	int a1 = IsDlgButtonChecked(IDC_CHECK1);
	int a2 = IsDlgButtonChecked(IDC_CHECK2);
	int a3 = IsDlgButtonChecked(IDC_CHECK3);
	int a4 = IsDlgButtonChecked(IDC_CHECK4);
	int a5 = IsDlgButtonChecked(IDC_CHECK5);
	int a6 = IsDlgButtonChecked(IDC_CHECK6);
	int a7 = IsDlgButtonChecked(IDC_CHECK7);

	unsigned char C = 
		(a0<<0) |
		(a1<<1) |
		(a2<<2) |
		(a3<<3) |
		(a4<<4) |
		(a5<<5) |
		(a6<<6) |
		(a7<<7);

	char s[16];
	sprintf(s,"0x%02X",C);
	this->SetDlgItemText(IDC_STATIC,s);

	WriteWord(0xA500 | C);
}

void CDevctrlDlg::OnCheck1() 
{
OnCheck0();
}

void CDevctrlDlg::OnCheck2() 
{
OnCheck0();
}

void CDevctrlDlg::OnCheck3() 
{
OnCheck0();
}

void CDevctrlDlg::OnCheck4() 
{
OnCheck0();
}

void CDevctrlDlg::OnCheck5() 
{
OnCheck0();
}

void CDevctrlDlg::OnCheck6() 
{
OnCheck0();
}

void CDevctrlDlg::OnCheck7() 
{
OnCheck0();
}
