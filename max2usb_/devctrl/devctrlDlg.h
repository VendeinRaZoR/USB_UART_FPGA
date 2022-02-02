// devctrlDlg.h : header file
//

#if !defined(AFX_DEVCTRLDLG_H__ABFB901D_AC37_4949_82C4_42B95CB8F138__INCLUDED_)
#define AFX_DEVCTRLDLG_H__ABFB901D_AC37_4949_82C4_42B95CB8F138__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

/////////////////////////////////////////////////////////////////////////////
// CDevctrlDlg dialog

class CDevctrlDlg : public CDialog
{
// Construction
public:
	CDevctrlDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	//{{AFX_DATA(CDevctrlDlg)
	enum { IDD = IDD_DEVCTRL_DIALOG };
	CTreeCtrl	m_tree;
	//}}AFX_DATA

	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CDevctrlDlg)
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support
	//}}AFX_VIRTUAL

// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	//{{AFX_MSG(CDevctrlDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	afx_msg void OnButtonScan();
	afx_msg void OnButton1();
	afx_msg void OnCheck0();
	afx_msg void OnCheck1();
	afx_msg void OnCheck2();
	afx_msg void OnCheck3();
	afx_msg void OnCheck4();
	afx_msg void OnCheck5();
	afx_msg void OnCheck6();
	afx_msg void OnCheck7();
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_DEVCTRLDLG_H__ABFB901D_AC37_4949_82C4_42B95CB8F138__INCLUDED_)
