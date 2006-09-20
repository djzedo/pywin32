/* File : win32file.i */
// @doc

%module win32file // An interface to the win32 File API's

%{

//#define UNICODE
#ifndef MS_WINCE
//#define FAR
#ifndef _WIN32_WINNT
#define _WIN32_WINNT 0x0500
#endif
#include "winsock2.h"
#include "mswsock.h"
#include "windows.h"
#include "winbase.h"
#include "assert.h"
#include <stddef.h>
#endif

#define NEED_PYWINOBJECTS_H
%}

%include "typemaps.i"
%include "pywin32.i"

#define FILE_GENERIC_READ FILE_GENERIC_READ
#define FILE_GENERIC_WRITE FILE_GENERIC_WRITE
#define FILE_ALL_ACCESS FILE_ALL_ACCESS

#define INVALID_HANDLE_VALUE (long)INVALID_HANDLE_VALUE

#define GENERIC_READ GENERIC_READ 
// Specifies read access to the object. Data can be read from the file and the file pointer can be moved. Combine with GENERIC_WRITE for read-write access. 
#define GENERIC_WRITE GENERIC_WRITE 
// Specifies write access to the object. Data can be written to the file and the file pointer can be moved. Combine with GENERIC_READ for read-write access. 
#define GENERIC_EXECUTE GENERIC_EXECUTE 
// Specifies execute access.
	
#ifndef MS_WINCE
#define FILE_SHARE_DELETE  FILE_SHARE_DELETE 
// Windows NT only: Subsequent open operations on the object will succeed only if delete access is requested. 
#endif
#define FILE_SHARE_READ FILE_SHARE_READ 
// Subsequent open operations on the object will succeed only if read access is requested. 
#define FILE_SHARE_WRITE FILE_SHARE_WRITE 
// Subsequent open operations on the object will succeed only if write access is requested. 
 
#define CREATE_NEW CREATE_NEW 
// Creates a new file. The function fails if the specified file already exists.
#define CREATE_ALWAYS CREATE_ALWAYS 
// Creates a new file. The function overwrites the file if it exists.
#define OPEN_EXISTING OPEN_EXISTING 
// Opens the file. The function fails if the file does not exist.
#define OPEN_ALWAYS OPEN_ALWAYS 
// Opens the file, if it exists. If the file does not exist, the function creates the file as if dwCreationDistribution were CREATE_NEW.
#define TRUNCATE_EXISTING TRUNCATE_EXISTING 
// Opens the file. Once opened, the file is truncated so that its size is zero bytes. The calling process must open the file with at least GENERIC_WRITE access. The function fails if the file does not exist.
 
#define FILE_ATTRIBUTE_ARCHIVE FILE_ATTRIBUTE_ARCHIVE 
// The file should be archived. Applications use this attribute to mark files for backup or removal.
#define FILE_ATTRIBUTE_DIRECTORY FILE_ATTRIBUTE_DIRECTORY
// The file is a directory
#define FILE_ATTRIBUTE_COMPRESSED FILE_ATTRIBUTE_COMPRESSED 
// The file or directory is compressed. For a file, this means that all of the data in the file is compressed. For a directory, this means that compression is the default for newly created files and subdirectories.
#define FILE_ATTRIBUTE_HIDDEN FILE_ATTRIBUTE_HIDDEN 
// The file is hidden. It is not to be included in an ordinary directory listing.
#define FILE_ATTRIBUTE_NORMAL FILE_ATTRIBUTE_NORMAL 
// The file has no other attributes set. This attribute is valid only if used alone.
#ifndef MS_WINCE
#define FILE_ATTRIBUTE_OFFLINE FILE_ATTRIBUTE_OFFLINE 
// The data of the file is not immediately available. Indicates that the file data has been physically moved to offline storage.
#endif // MS_WINCE
#define FILE_ATTRIBUTE_READONLY FILE_ATTRIBUTE_READONLY 
// The file is read only. Applications can read the file but cannot write to it or delete it.
#define FILE_ATTRIBUTE_SYSTEM FILE_ATTRIBUTE_SYSTEM 
// The file is part of or is used exclusively by the operating system.
#define FILE_ATTRIBUTE_TEMPORARY FILE_ATTRIBUTE_TEMPORARY 
// The file is being used for temporary storage. File systems attempt to keep all of the data in memory for quicker access rather than flushing the data back to mass storage. A temporary file should be deleted by the application as soon as it is no longer needed.
 
#define FILE_FLAG_WRITE_THROUGH FILE_FLAG_WRITE_THROUGH 
// Instructs the system to write through any intermediate cache and go directly to disk. Windows can still cache write operations, but cannot lazily flush them.
#define FILE_FLAG_OVERLAPPED FILE_FLAG_OVERLAPPED 
// Instructs the system to initialize the object, so that operations that take a significant amount of time to process return ERROR_IO_PENDING. When the operation is finished, the specified event is set to the signaled state.
	// When you specify FILE_FLAG_OVERLAPPED, the ReadFile and WriteFile functions must specify an OVERLAPPED structure. That is, when FILE_FLAG_OVERLAPPED is specified, an application must perform overlapped reading and writing.
	// When FILE_FLAG_OVERLAPPED is specified, the system does not maintain the file pointer. The file position must be passed as part of the lpOverlapped parameter (pointing to an OVERLAPPED structure) to the ReadFile and WriteFile functions.
	// This flag also enables more than one operation to be performed simultaneously with the handle (a simultaneous read and write operation, for example).
#define FILE_FLAG_NO_BUFFERING FILE_FLAG_NO_BUFFERING 
// Instructs the system to open the file with no intermediate buffering or caching. 
	// When combined with FILE_FLAG_OVERLAPPED, the flag gives maximum asynchronous performance, 
	// because the I/O does not rely on the synchronous operations of the memory 
	// manager. However, some I/O operations will take longer, because data is 
	// not being held in the cache. An application must meet certain requirements 
	// when working with files opened with FILE_FLAG_NO_BUFFERING:
	// <nl>-	File access must begin at byte offsets within the file that are integer multiples of the volume's sector size.
	// <nl>-	File access must be for numbers of bytes that are integer multiples of the volume's sector size. 
	// For example, if the sector size is 512 bytes, an application can request reads and writes of 512, 1024, or 2048 bytes, but not of 335, 981, or 7171 bytes.
	// <nl>-	Buffer addresses for read and write operations must be aligned on addresses in memory that are integer multiples of the volume's sector size. 
	// One way to align buffers on integer multiples of the volume sector size is to use VirtualAlloc to allocate the 
	// buffers. It allocates memory that is aligned on addresses that are integer multiples of the operating system's memory page size. Because both memory page 
	// and volume sector sizes are powers of 2, this memory is also aligned on addresses that are integer multiples of a volume's sector size. An application can 
	// determine a volume's sector size by calling the GetDiskFreeSpace function. 
#define FILE_FLAG_RANDOM_ACCESS FILE_FLAG_RANDOM_ACCESS 
// Indicates that the file is accessed randomly. The system can use this as a hint to optimize file caching.
#define FILE_FLAG_SEQUENTIAL_SCAN FILE_FLAG_SEQUENTIAL_SCAN 
// Indicates that the file is to be accessed sequentially from beginning to end. The system can use this as a hint to optimize file caching. 
	// If an application moves the file pointer for random access, optimum caching may not occur; however, correct operation is still guaranteed.
	// Specifying this flag can increase performance for applications that read large files using sequential access. 
	// Performance gains can be even more noticeable for applications that read large files mostly sequentially, but occasionally skip over small ranges of bytes.
#define FILE_FLAG_DELETE_ON_CLOSE FILE_FLAG_DELETE_ON_CLOSE 
// Indicates that the operating system is to delete the file immediately after all of its handles have been closed, 
	// not just the handle for which you specified FILE_FLAG_DELETE_ON_CLOSE. Subsequent open requests for the file will fail, unless FILE_SHARE_DELETE is used. 
#define FILE_FLAG_BACKUP_SEMANTICS FILE_FLAG_BACKUP_SEMANTICS 
// Windows NT only: Indicates that the file is being opened or created for a backup or restore operation. 
	// The operating system ensures that the calling process overrides file security checks, provided it has the necessary permission to do so. The relevant permissions are SE_BACKUP_NAME and SE_RESTORE_NAME.
	// You can also set this flag to obtain a handle to a directory. A directory handle can be passed to some Win32 functions in place of a file handle.
#define FILE_FLAG_POSIX_SEMANTICS FILE_FLAG_POSIX_SEMANTICS 
// Indicates that the file is to be accessed according to POSIX rules. 
	// This includes allowing multiple files with names, differing only in case, for file systems that support such naming. 
	// Use care when using this option because files created with this flag may not be accessible by applications written for MS-DOS or Windows.
#define FILE_FLAG_OPEN_REPARSE_POINT FILE_FLAG_OPEN_REPARSE_POINT
// used to open a handle for use with DeviceIoControl and FSCTL_GET_REPARSE_POINT/FSCTL_SET_REPARSE_POINT)

#ifndef MS_WINCE
#define SECURITY_ANONYMOUS SECURITY_ANONYMOUS 
// Specifies to impersonate the client at the Anonymous impersonation level.
#define SECURITY_IDENTIFICATION SECURITY_IDENTIFICATION 
// Specifies to impersonate the client at the Identification impersonation level.
#define SECURITY_IMPERSONATION SECURITY_IMPERSONATION 
// Specifies to impersonate the client at the Impersonation impersonation level.
#define SECURITY_DELEGATION SECURITY_DELEGATION 
// Specifies to impersonate the client at the Delegation impersonation level.
#define SECURITY_CONTEXT_TRACKING SECURITY_CONTEXT_TRACKING 
// Specifies that the security tracking mode is dynamic. If this flag is not specified, Security Tracking Mode is static.
#define SECURITY_EFFECTIVE_ONLY SECURITY_EFFECTIVE_ONLY 
// Specifies that only the enabled aspects 	
#endif // MS_WINCE

#ifndef MS_WINCE /* Not on CE */

// @pyswig int|AreFileApisANSI|Determines whether a set of Win32 file functions is using the ANSI or OEM character set code page. This function is useful for 8-bit console input and output operations.
BOOL AreFileApisANSI(void);

#endif // MS_WINCE

// @pyswig |CancelIo|Cancels pending IO requests for the object.
// @pyparm <o PyHANDLE>|handle||The handle being cancelled.
BOOLAPI CancelIo(PyHANDLE handle);

// @pyswig |CopyFile|Copies a file
BOOLAPI CopyFile(
    TCHAR *from, // @pyparm <o PyUnicode>|from||The name of the file to copy from
    TCHAR *to, // @pyparm <o PyUnicode>|to||The name of the file to copy to
    BOOL bFailIfExists); // @pyparm int|bFailIfExists||Indicates if the operation should fail if the file exists.

// @pyswig |CopyFileW|Copies a file (NT/2000 Unicode specific version)
BOOLAPI CopyFileW(
    WCHAR *from, // @pyparm <o PyUnicode>|from||The name of the file to copy from
    WCHAR *to, // @pyparm <o PyUnicode>|to||The name of the file to copy to
    BOOL bFailIfExists); // @pyparm int|bFailIfExists||Indicates if the operation should fail if the file exists.

// @pyswig |CreateDirectory|Creates a directory
BOOLAPI CreateDirectory(
    TCHAR *name, // @pyparm <o PyUnicode>|name||The name of the directory to create
    SECURITY_ATTRIBUTES *pSA); // @pyparm <o PySECURITY_ATTRIBUTES>|sa||The security attributes, or None

// @pyswig |CreateDirectoryW|Creates a directory (NT/2000 Unicode specific version)
BOOLAPI CreateDirectoryW(
    WCHAR *name, // @pyparm <o PyUnicode>|name||The name of the directory to create
    SECURITY_ATTRIBUTES *pSA); // @pyparm <o PySECURITY_ATTRIBUTES>|sa||The security attributes, or None

#ifndef MS_WINCE
// @pyswig |CreateDirectoryEx|Creates a directory
BOOLAPI CreateDirectoryEx(
    TCHAR *templateName, // @pyparm <o PyUnicode>|templateName||Specifies the path of the directory to use as a template when creating the new directory. 
    TCHAR *newDirectory, // @pyparm <o PyUnicode>|newDirectory||Specifies the name of the new directory
    SECURITY_ATTRIBUTES *pSA); // @pyparm <o PySECURITY_ATTRIBUTES>|sa||The security attributes, or None

// @pyswig |CreateDirectoryExW|Creates a directory (NT/2000 Unicode specific version)
BOOLAPI CreateDirectoryExW(
    WCHAR *templateName, // @pyparm <o PyUnicode>|templateName||Specifies the path of the directory to use as a template when creating the new directory. 
    WCHAR *newDirectory, // @pyparm <o PyUnicode>|newDirectory||Specifies the name of the new directory
    SECURITY_ATTRIBUTES *pSA); // @pyparm <o PySECURITY_ATTRIBUTES>|sa||The security attributes, or None
#endif // MS_WINCE

// @pyswig <o PyHANDLE>|CreateFile|Creates or opens the a file or other object and returns a handle that can be used to access the object.
// @comm The following objects can be opened:<nl>files<nl>pipes<nl>mailslots<nl>communications resources<nl>disk devices (Windows NT only)<nl>consoles<nl>directories (open only)
PyHANDLE CreateFile(
    TCHAR *lpFileName,	// @pyparm <o PyUnicode>|fileName||The name of the file
    DWORD dwDesiredAccess,	// @pyparm int|desiredAccess||access (read-write) mode
			// Specifies the type of access to the object. An application can obtain read access, write access, read-write access, or device query access. This parameter can be any combination of the following values. 
			// @flagh Value|Meaning 
			// @flag 0|Specifies device query access to the object. An application can query device attributes without accessing the device.
			// @flag GENERIC_READ|Specifies read access to the object. Data can be read from the file and the file pointer can be moved. Combine with GENERIC_WRITE for read-write access.  
			// @flag GENERIC_WRITE|Specifies write access to the object. Data can be written to the file and the file pointer can be moved. Combine with GENERIC_READ for read-write access.
    DWORD dwShareMode,	// @pyparm int|shareMode||Set of bit flags that specifies how the object can be shared. If dwShareMode is 0, the object cannot be shared. Subsequent open operations on the object will fail, until the handle is closed. 
			// To share the object, use a combination of one or more of the following values:
			// @flagh Value|Meaning 
			// @flag FILE_SHARE_DELETE|Windows NT: Subsequent open operations on the object will succeed only if delete access is requested.  
			// @flag FILE_SHARE_READ|Subsequent open operations on the object will succeed only if read access is requested.
			// @flag FILE_SHARE_WRITE|Subsequent open operations on the object will succeed only if write access is requested.
    SECURITY_ATTRIBUTES *lpSecurityAttributes,	// @pyparm <o PySECURITY_ATTRIBUTES>|attributes||The security attributes, or None
    DWORD dwCreationDistribution,	// @pyparm int|creationDisposition||Specifies which action to take on files that exist, and which action to take when files do not exist. For more information about this parameter, see the Remarks section. This parameter must be one of the following values:
			// @flagh Value|Meaning
			// @flag CREATE_NEW|Creates a new file. The function fails if the specified file already exists. 
			// @flag CREATE_ALWAYS|Creates a new file. If the file exists, the function overwrites the file and clears the existing attributes. 
			// @flag OPEN_EXISTING|Opens the file. The function fails if the file does not exist. 
			//       See the Remarks section for a discussion of why you should use the OPEN_EXISTING flag if you are using the CreateFile function for devices, including the console. 
			// @flag OPEN_ALWAYS|Opens the file, if it exists. If the file does not exist, the function creates the file as if dwCreationDisposition were CREATE_NEW. 
			// @flag TRUNCATE_EXISTING|Opens the file. Once opened, the file is truncated so that its size is zero bytes. The calling process must open the file with at least GENERIC_WRITE access. The function fails if the file does not exist. 
    DWORD dwFlagsAndAttributes,	// @pyparm int|flagsAndAttributes||file attributes
    PyHANDLE INPUT_NULLOK // @pyparm <o PyHANDLE>|hTemplateFile||Specifies a handle with GENERIC_READ access to a template file. The template file supplies file attributes and extended attributes for the file being created.   Under Win95, this must be 0, else an exception will be raised.
);

// @pyswig <o PyHANDLE>|CreateFileW|An NT/2000 specific Unicode version of CreateFile - see <om win32file.CreateFile> for more information.
PyHANDLE CreateFileW(
    WCHAR *lpFileName,	// @pyparm <o PyUnicode>|fileName||The name of the file
    DWORD dwDesiredAccess,	// @pyparm int|desiredAccess||access (read-write) mode
    DWORD dwShareMode,	// @pyparm int|shareMode||Set of bit flags that specifies how the object can be shared. If dwShareMode is 0, the object cannot be shared. Subsequent open operations on the object will fail, until the handle is closed. 
    SECURITY_ATTRIBUTES *lpSecurityAttributes,	// @pyparm <o PySECURITY_ATTRIBUTES>|attributes||The security attributes, or None
    DWORD dwCreationDistribution,	// @pyparm int|creationDisposition||Specifies which action to take on files that exist, and which action to take when files do not exist. For more information about this parameter, see <om win32file.CreateFile>
    DWORD dwFlagsAndAttributes,	// @pyparm int|flagsAndAttributes||file attributes
    PyHANDLE INPUT_NULLOK // @pyparm <o PyHANDLE>|hTemplateFile||Specifies a handle with GENERIC_READ access to a template file. The template file supplies file attributes and extended attributes for the file being created.
);

#ifndef MS_WINCE
// CreateIoCompletionPort gets special treatment due to its special result
// code handling.

%{
// @pyswig <o PyHANDLE>|CreateIoCompletionPort|Can associate an instance of an opened file with a newly created or an existing input/output (I/O) completion port; or it can create an I/O completion port without associating it with a file.
// @rdesc If an existing handle to a completion port is passed, the result
// of this function will be that same handle.  See MSDN for more details.
PyObject *MyCreateIoCompletionPort(PyObject *self, PyObject *args)
{
    PyObject *obFileHandle, *obExistingHandle;
    int key, nt;
    PyObject *obRet = NULL;
    if (!PyArg_ParseTuple(args, "OOii:CreateIoCompletionPort",
                          &obFileHandle, // @pyparm <o PyHANDLE>|handle||file handle to associate with the I/O completion port
                          &obExistingHandle, // @pyparm <o PyHANDLE>|existing||handle to the I/O completion port
                          &key, // @pyparm int|completionKey||per-file completion key for I/O completion packets
                          &nt)) // @pyparm int|numThreads||number of threads allowed to execute concurrently
        return NULL;
    HANDLE hFile, hExisting;
    if (!PyWinObject_AsHANDLE(obFileHandle, &hFile, FALSE))
        return NULL;
    if (!PyWinObject_AsHANDLE(obExistingHandle, &hExisting, TRUE))
        return NULL;
    if (hExisting) {
        obRet = obExistingHandle;
        Py_INCREF(obRet);
    }
    HANDLE hRet;
    Py_BEGIN_ALLOW_THREADS
    hRet = CreateIoCompletionPort(hFile, hExisting, key, nt);
    Py_END_ALLOW_THREADS
    if (!hRet) {
        Py_XDECREF(obRet);
        return PyWin_SetAPIError("CreateIoCompletionPort");
    }
    if (obRet==NULL) // New handle returned
        obRet = PyWinObject_FromHANDLE(hRet);
    else
        // it better have returned the same object!
        assert(hRet == hExisting);
    return obRet;
}

%}

%native (CreateIoCompletionPort) MyCreateIoCompletionPort;

// @pyswig |DefineDosDevice|Lets an application define, redefine, or delete MS-DOS device names. 
BOOLAPI DefineDosDevice(
    DWORD dwFlags,	// @pyparm int|flags||flags specifying aspects of device definition  
    TCHAR *lpDeviceName,	// @pyparm <o PyUnicode>|deviceName||MS-DOS device name string  
    TCHAR *lpTargetPath	// @pyparm <o PyUnicode>|targetPath||MS-DOS or path string for 32-bit Windows.
);
// @pyswig |DefineDosDeviceW|Lets an application define, redefine, or delete MS-DOS device names. (NT/2000 Unicode specific version)
BOOLAPI DefineDosDeviceW(
    DWORD dwFlags,	// @pyparm int|flags||flags specifying aspects of device definition  
    WCHAR *lpDeviceName,	// @pyparm <o PyUnicode>|deviceName||MS-DOS device name string  
    WCHAR *lpTargetPath	// @pyparm <o PyUnicode>|targetPath||MS-DOS or path string for 32-bit Windows.
);
#endif // MS_WINCE

// @pyswig |DeleteFile|Deletes a file.
BOOLAPI DeleteFile(TCHAR *fileName);
// @pyparm <o PyUnicode>|fileName||The filename to delete

// @pyswig |DeleteFileW|Deletes a file (NT/2000 Unicode specific version)
BOOLAPI DeleteFileW(WCHAR *fileName);
// @pyparm <o PyUnicode>|fileName||The filename to delete

%{
// @pyswig string|DeviceIoControl|Call DeviceIoControl
PyObject *MyDeviceIoControl(PyObject *self, PyObject *args)
{
    OVERLAPPED *pOverlapped;
    PyObject *obhFile;
    HANDLE hDevice;
    DWORD readSize;
    PyObject *obOverlapped = NULL;

    DWORD dwIoControlCode;
    char *writeData;
    DWORD writeSize;

    if (!PyArg_ParseTuple(args, "Ols#l|O:DeviceIoControl", 
        &obhFile, // @pyparm int|hFile||Handle to the file
        &dwIoControlCode, // @pyparm int|dwIoControlCode||IOControl Code to use.
        &writeData, &writeSize, // @pyparm string|data||The data to write.
        &readSize, // @pyparm int|readSize||Size of the buffer to create for the read.
        &obOverlapped)) // @pyparm <o PyOVERLAPPED>|ol|None|An overlapped structure
        return NULL;
    if (obOverlapped==NULL)
        pOverlapped = NULL;
    else {
        if (!PyWinObject_AsOVERLAPPED(obOverlapped, &pOverlapped))
            return NULL;
    }
    if (!PyWinObject_AsHANDLE(obhFile, &hDevice))
        return NULL;

    void *readData = malloc(readSize);
    DWORD numRead;
    BOOL ok;
    Py_BEGIN_ALLOW_THREADS

    ok = DeviceIoControl(hDevice,
                         dwIoControlCode,
                         writeData,
                         writeSize,
                         readData, 
                         readSize, 
                         &numRead,
                         pOverlapped);

    Py_END_ALLOW_THREADS
    if (!ok) {
        free(readData);
        return PyWin_SetAPIError("DeviceIoControl");
    }
    
    PyObject *result = PyString_FromStringAndSize((char *)readData, numRead);
    free(readData);
    return result;
}
%}

%native (OVERLAPPED) PyWinMethod_NewOVERLAPPED;
%native(DeviceIoControl) MyDeviceIoControl;


//FileIOCompletionRoutine	

// @pyswig |FindClose|Closes a handle opened with <om win32file.FindOpen>
BOOLAPI FindClose(HANDLE hFindFile);	// @pyparm int|hFindFile||file search handle

#ifndef MS_WINCE 
// @pyswig |FindCloseChangeNotification|Closes a handle.
BOOLAPI FindCloseChangeNotification(
    HANDLE hChangeHandle 	// @pyparm int|hChangeHandle||handle to change notification to close
);

// @pyswig int|FindFirstChangeNotification|Creates a change notification handle and sets up initial change notification filter conditions. A wait on a notification handle succeeds when a change matching the filter conditions occurs in the specified directory or subtree. 
HANDLE FindFirstChangeNotification(
    TCHAR *lpPathName,	// @pyparm <o PyUnicode>|pathName||Name of directory to watch  
    BOOL bWatchSubtree,	// @pyparm int|bWatchSubtree||flag for monitoring directory or directory tree  
    DWORD dwNotifyFilter 	// @pyparm int|notifyFilter||filter conditions to watch for.  See <om win32api.FindFirstChangeNotification> for details.
);

//FindFirstFile	
//FindFirstFileEx	
// FindNextFile	

// @pyswig int|FindNextChangeNotification|Requests that the operating system signal a change notification handle the next time it detects an appropriate change,
BOOLAPI FindNextChangeNotification(
    HANDLE hChangeHandle 	//  @pyparm int|hChangeHandle||handle to change notification to signal  
);

#endif // MS_WINCE

%{
// @pyswig list|FindFilesW|Retrieves a list of matching filenames, using the Windows Unicode API.  An interface to the API FindFirstFileW/FindNextFileW/Find close functions.
static PyObject *
PyFindFilesW(PyObject *self, PyObject *args)
{
	WCHAR *fileSpec;
	// @pyparm string|fileSpec||A string that specifies a valid directory or path and filename, which can contain wildcard characters (* and ?).
	PyObject *obfileSpec=NULL;
	if (!PyArg_ParseTuple (args, "O:FindFilesW", &obfileSpec))
		return NULL;
	if (!PyWinObject_AsWCHAR(obfileSpec,&fileSpec,FALSE))
		return NULL;
	WIN32_FIND_DATAW findData;
	// @pyseeapi FindFirstFile
	HANDLE hFind;

	memset(&findData, 0, sizeof(findData));
	hFind =  ::FindFirstFileW(fileSpec, &findData);
	PyWinObject_FreeWCHAR(fileSpec);
	if (hFind==INVALID_HANDLE_VALUE) {
		if (::GetLastError()==ERROR_FILE_NOT_FOUND) {	// this is OK
			return PyList_New(0);
		}
		return PyWin_SetAPIError("FindFirstFileW");
	}
	PyObject *retList = PyList_New(0);
	if (!retList) {
		::FindClose(hFind);
		return NULL;
	}
	// @rdesc The return value is a list of <o WIN32_FIND_DATA> tuples.
	BOOL ok = TRUE;
	while (ok) {
		PyObject *newItem = PyObject_FromWIN32_FIND_DATAW(&findData);
		if (!newItem) {
			::FindClose(hFind);
			Py_DECREF(retList);
			return NULL;
		}
		PyList_Append(retList, newItem);
		Py_DECREF(newItem);
		// @pyseeapi FindNextFile
		memset(&findData, 0, sizeof(findData));
		ok=::FindNextFileW(hFind, &findData);
	}
	ok = (GetLastError()==ERROR_NO_MORE_FILES);
	// @pyseeapi FindClose
	::FindClose(hFind);
	if (!ok) {
		Py_DECREF(retList);
		return PyWin_SetAPIError("FindNextFileW");
	}
	return retList;
}
%}

%native(FindFilesW) PyFindFilesW;

%{

typedef struct {
	PyObject_HEAD
	HANDLE hFind;
	WIN32_FIND_DATAW buffer;
	BOOL seen_first;
	BOOL empty;
} FindFileIterator;


static void
ffi_dealloc(FindFileIterator *it)
{
	if (it->hFind != INVALID_HANDLE_VALUE)
		::FindClose(it->hFind);
	PyObject_Del(it);
}

static PyObject *
ffi_iternext(PyObject *iterator)
{
	FindFileIterator *ffi = (FindFileIterator *)iterator;
	if (ffi->empty) {
		PyErr_SetNone(PyExc_StopIteration);
		return NULL;
	}
	if (!ffi->seen_first)
		ffi->seen_first = TRUE;
	else {
		BOOL ok;
		Py_BEGIN_ALLOW_THREADS
		memset(&ffi->buffer, 0, sizeof(ffi->buffer));
		ok = ::FindNextFileW(ffi->hFind, &ffi->buffer);
		Py_END_ALLOW_THREADS
		if (!ok) {
			if (GetLastError()==ERROR_NO_MORE_FILES) {
				PyErr_SetNone(PyExc_StopIteration);
				return NULL;
			}
			return PyWin_SetAPIError("FindNextFileW");
		}
	}
	return PyObject_FromWIN32_FIND_DATAW(&ffi->buffer);
}

PyTypeObject FindFileIterator_Type = {
	PyObject_HEAD_INIT(&PyType_Type)
	0,					/* ob_size */
	"FindFileIterator",				/* tp_name */
	sizeof(FindFileIterator),			/* tp_basicsize */
	0,					/* tp_itemsize */
	/* methods */
	(destructor)ffi_dealloc, 		/* tp_dealloc */
	0,					/* tp_print */
	0,					/* tp_getattr */
	0,					/* tp_setattr */
	0,					/* tp_compare */
	0,					/* tp_repr */
	0,					/* tp_as_number */
	0,					/* tp_as_sequence */
	0,					/* tp_as_mapping */
	0,					/* tp_hash */
	0,					/* tp_call */
	0,					/* tp_str */
	PyObject_GenericGetAttr,		/* tp_getattro */
	0,					/* tp_setattro */
	0,					/* tp_as_buffer */
	Py_TPFLAGS_DEFAULT, /* tp_flags */
 	0,					/* tp_doc */
 	0,					/* tp_traverse */
 	0,					/* tp_clear */
	0,					/* tp_richcompare */
	0,					/* tp_weaklistoffset */
#if (PY_VERSION_HEX >= 0x02030000) // Iterators only in 2.3+
	PyObject_SelfIter,	/* tp_iter */
	(iternextfunc)ffi_iternext,		/* tp_iternext */
	0,					/* tp_methods */
	0,					/* tp_members */
	0,					/* tp_getset */
	0,					/* tp_base */
	0,					/* tp_dict */
	0,					/* tp_descr_get */
	0,					/* tp_descr_set */
#endif // PY_VERSION
};

// @pyswig iterator|FindFilesIterator|Returns an interator based on
// FindFirstFile/FindNextFile. Similar to <om win32file.FindFiles>, but
// avoids the creation of the list for huge directories
static PyObject *
PyFindFilesIterator(PyObject *self, PyObject *args)
{
	WCHAR *fileSpec;
	PyObject *obfileSpec=NULL;
	// @pyparm unicode|filespec||
	if (!PyArg_ParseTuple (args, "O:FindFilesIterator", &obfileSpec))
		return NULL;

	if (!PyWinObject_AsWCHAR(obfileSpec,&fileSpec,FALSE))
		return NULL;

	FindFileIterator *it = PyObject_New(FindFileIterator, &FindFileIterator_Type);
	if (it == NULL) {
		PyWinObject_FreeWCHAR(fileSpec);
		return NULL;
	}
	it->seen_first = FALSE;
	it->empty = FALSE;
	it->hFind = INVALID_HANDLE_VALUE;
	memset(&it->buffer, 0, sizeof(it->buffer));

	Py_BEGIN_ALLOW_THREADS
	it->hFind =  ::FindFirstFileW(fileSpec, &it->buffer);
	Py_END_ALLOW_THREADS
	PyWinObject_FreeWCHAR(fileSpec);

	if (it->hFind==INVALID_HANDLE_VALUE) {
		if (::GetLastError()!=ERROR_FILE_NOT_FOUND) {	// this is OK
			Py_DECREF(it);
			return PyWin_SetAPIError("FindFirstFileW");
		}
		it->empty = TRUE;
	}
	return (PyObject *)it;
	// @rdesc The result is a Python iterator, with each next() method
	// returning a <o WIN32_FIND_DATA> tuple.
}
%}

%native(FindFilesIterator) PyFindFilesIterator;


// @pyswig |FlushFileBuffers|Clears the buffers for the specified file and causes all buffered data to be written to the file. 
BOOLAPI FlushFileBuffers(
   PyHANDLE hFile 	// @pyparm <o PyHANDLE>|hFile||open handle to file whose buffers are to be flushed 
);

#ifndef MS_WINCE
// @pyswig int|GetBinaryType|Determines whether a file is executable, and if so, what type of executable file it is. That last property determines which subsystem an executable file runs under.
BOOLAPI GetBinaryType(
    TCHAR *lpApplicationName,	// @pyparm <o PyUnicode>|appName||Fully qualified path of file to test
    unsigned long *OUTPUT	// DWORD
   );
#define SCS_32BIT_BINARY SCS_32BIT_BINARY // A Win32-based application
#define SCS_DOS_BINARY SCS_DOS_BINARY // An MS-DOS - based application
#define SCS_OS216_BINARY SCS_OS216_BINARY // A 16-bit OS/2-based application
#define SCS_PIF_BINARY SCS_PIF_BINARY // A PIF file that executes an MS-DOS - based application
#define SCS_POSIX_BINARY SCS_POSIX_BINARY // A POSIX - based application
#define SCS_WOW_BINARY SCS_WOW_BINARY // A 16-bit Windows-based application
#endif // MS_WINCE

//GetCurrentDirectory

#ifndef MS_WINCE
// @pyswig (int, int, int, int)|GetDiskFreeSpace|Determines the free space on a device.
BOOLAPI GetDiskFreeSpace(
    TCHAR *lpRootPathName,	// @pyparm <o PyUnicode>|rootPathName||address of root path
    unsigned long *OUTPUT,
    unsigned long *OUTPUT,
    unsigned long *OUTPUT,
    unsigned long *OUTPUT
// @rdesc The result is a tuple of integers representing (sectors per cluster, bytes per sector, number of free clusters, total number of clusters)
);

// GetDiskFreeSpaceEx	
// @pyswig long, long, long|GetDiskFreeSpaceEx|Determines the free space on a device.
BOOLAPI GetDiskFreeSpaceEx(
    TCHAR *lpRootPathName,	// @pyparm <o PyUnicode>|rootPathName||address of root path
    ULARGE_INTEGER *OUTPUT, 
    ULARGE_INTEGER *OUTPUT,
    ULARGE_INTEGER *OUTPUT 
// @rdesc The result is a tuple of long integers:
// @tupleitem 0|long integer|freeBytes|The total number of free bytes on the disk that are available to the user associated with the calling thread.
// @tupleitem 1|long integer|totalBytes|The total number of bytes on the disk that are available to the user associated with the calling thread.
// Windows 2000: If per-user quotas are in use, this value may be less than the total number of bytes on the disk. 
// @tupleitem 2|long integer|totalFreeBytes|The total number of free bytes on the disk. 
);

// @pyswig int|GetDriveType|Determines whether a disk drive is a removable, fixed, CD-ROM, RAM disk, or network drive. 
long GetDriveType(
    TCHAR *rootPathName
// @rdesc The result is one of the DRIVE_* constants.
);
// @pyswig int|GetDriveTypeW|Determines whether a disk drive is a removable, fixed, CD-ROM, RAM disk, or network drive. (NT/2000 Unicode specific version).
long GetDriveTypeW(
    WCHAR *rootPathName
// @rdesc The result is one of the DRIVE_* constants.
);

#define DRIVE_UNKNOWN DRIVE_UNKNOWN // The drive type cannot be determined.
#define DRIVE_NO_ROOT_DIR DRIVE_NO_ROOT_DIR // The root directory does not exist.
#define DRIVE_REMOVABLE DRIVE_REMOVABLE // The disk can be removed from the drive.
#define DRIVE_FIXED DRIVE_FIXED // The disk cannot be removed from the drive.
#define DRIVE_REMOTE DRIVE_REMOTE // The drive is a remote (network) drive.
#define DRIVE_CDROM DRIVE_CDROM // The drive is a CD-ROM drive.
#define DRIVE_RAMDISK DRIVE_RAMDISK // The drive is a RAM disk.

#endif // MS_WINCE


// @pyswig int|GetFileAttributes|Determines a files attributes.
// @comm The win32file module exposes <om win32file.GetFileAttributes> and
// <om win32file.GetFileAttributesW> separately - both functions will accept
// either strings or Unicode objects but will always call the named function.
// This is different than <om win32api.GetFileAttributes>, which only exposes
// one Python function and automatically calls the appropriate win32 function
// based on the type of the filename param.
DWORD GetFileAttributes(
    TCHAR *fileName); // @pyparm <o PyUnicode>|fileName||Name of the file to retrieve attributes for.

// @pyswig int|GetFileAttributesW|Determines a files attributes (NT/2000 Unicode specific version).
// @comm Note that <om win32api.GetFileAttributes> will automatically call
// GetFileAttributesW when passed a unicode filename param.  See <om win32file.GetFileAttributes>
// and <om win32api.GetFileAttributes> for more.
DWORD GetFileAttributesW(
    WCHAR *fileName); // @pyparm <o PyUnicode>|fileName||Name of the file to retrieve attributes for.

// @pyswig int|GetFileTime|Determine a file access/modification times.
DWORD GetFileTime(
    HANDLE handle, // @pyparm <o PyHANDLE>|handle||Handle to the file.
	FILETIME *OUTPUT, // @pyparm <o PyTime>|creationTime||
	FILETIME *OUTPUT, // @pyparm <o PyTime>|accessTime||
	FILETIME *OUTPUT // @pyparm <o PyTime>|writeTime||
);

%{
static PyObject *PyObject_FromFILEX_INFO(GET_FILEEX_INFO_LEVELS level, void *p)
{
	switch (level) {
		case GetFileExInfoStandard: {
			WIN32_FILE_ATTRIBUTE_DATA *pa = (WIN32_FILE_ATTRIBUTE_DATA *)p;
			return Py_BuildValue("iNNNN",
			             pa->dwFileAttributes,
						 PyWinObject_FromFILETIME(pa->ftCreationTime),
						 PyWinObject_FromFILETIME(pa->ftLastAccessTime),
						 PyWinObject_FromFILETIME(pa->ftLastWriteTime),
			             PyLong_FromTwoInts(pa->nFileSizeHigh, pa->nFileSizeLow));
			break;
		}
			
		default:
			PyErr_Format(PyExc_RuntimeError, "invalid level for FILEEX_INFO");
			return NULL;
	}
	assert(0); // "not reached";
	return NULL;
}

static PyObject *_DoGetFileAttributesEx(PyObject *self, PyObject *args, BOOL bUnicode)
{
	BOOL ok;
	PyObject *ret = NULL;
	PyObject *obName;
	char *fname = NULL; WCHAR *wname = NULL; // only one of these used.
	int level = (int)GetFileExInfoStandard;
	void *buffer = NULL;
	int nbytes;
	if (!PyArg_ParseTuple(args, "O|i", &obName, &level))
		return NULL;
	if (bUnicode)
		ok = PyWinObject_AsWCHAR(obName, &wname, FALSE);
	else
		ok = PyWinObject_AsString(obName, &fname, FALSE);
	if (!ok)
		goto done;

	switch (level) {
		case GetFileExInfoStandard:
			nbytes = sizeof WIN32_FILE_ATTRIBUTE_DATA;
			break;
		default:
			PyErr_Format(PyExc_ValueError, "Level '%d' is not supported", level);
			goto done;
	}
	buffer = malloc(nbytes);
	if (!buffer) {
		PyErr_Format(PyExc_MemoryError, "Error allocting buffer");
		goto done;
	}
	Py_BEGIN_ALLOW_THREADS
	ok = bUnicode ? 
			GetFileAttributesExW(wname, (GET_FILEEX_INFO_LEVELS)level, buffer) :
			GetFileAttributesEx(fname, (GET_FILEEX_INFO_LEVELS)level, buffer);
	Py_END_ALLOW_THREADS
	if (!ok) {
		PyWin_SetAPIError("GetFileAttributesEx");
		goto done;
	}
	ret = PyObject_FromFILEX_INFO((GET_FILEEX_INFO_LEVELS)level, buffer);
done:
	PyWinObject_FreeString(fname);
	PyWinObject_FreeString(wname);
	if (buffer) free(buffer);
	return ret;
}

// @pyswig tuple|GetFileAttributesEx|Retrieves attributes for a specified file or directory.
// @pyparm string/unicode|filename||String that specifies a file or directory.
// Windows NT/2000: In the ANSI version of this function, the name is limited to 
// MAX_PATH characters. To extend this limit to nearly 32,000 wide characters, 
// call the Unicode version of the function (<om win32file.GetFileAttributesExW>) and prepend 
// "\\?\" to the path.
// @pyparm int|level|GetFileExInfoStandard|An integer that gives the set of attribute information to obtain.
// See the Win32 SDK documentation for more information.
// @rdesc The result is a tuple of:
// @tupleitem 0|int|attributes|File Attributes.  A combination of the win32com.FILE_ATTRIBUTE_* flags.
// @tupleitem 1|<o PyTime>|creationTime|Specifies when the file or directory was created. 
// @tupleitem 2|<o PyTime>|lastAccessTime|For a file, specifies when the file was last read from 
// or written to. For a directory, the structure specifies when the directory was created. For 
// both files and directories, the specified date will be correct, but the time of day will 
// always be set to midnight.
// @tupleitem 3|<o PyTime>|lastWriteTime|For a file, the structure specifies when the file was last 
// written to. For a directory, the structure specifies when the directory was created.
// @tupleitem 4|int/long|fileSize|The size of the file. This member has no meaning for directories. 
// @comm Not all file systems can record creation and last access time and not all file systems record 
// them in the same manner. For example, on Windows NT FAT, create time has a resolution of 
// 10 milliseconds, write time has a resolution of 2 seconds, and access time has a resolution 
// of 1 day (really, the access date). On NTFS, access time has a resolution of 1 hour. 
// Furthermore, FAT records times on disk in local time, while NTFS records times on disk in UTC, 
// so it is not affected by changes in time zone or daylight saving time.
static PyObject *PyGetFileAttributesEx(PyObject *self, PyObject *args)
{
	return _DoGetFileAttributesEx(self, args, FALSE);
}
// @pyswig tuple|GetFileAttributesExW|Retrieves attributes for a specified file or directory using Unicode paths.
// @comm See <om win32file.GetFileAttributesEx> for a description of the arguments and return type.
static PyObject *PyGetFileAttributesExW(PyObject *self, PyObject *args)
{
	return _DoGetFileAttributesEx(self, args, TRUE);
}

%}
%native(GetFileAttributesEx) PyGetFileAttributesEx;
%native(GetFileAttributesExW) PyGetFileAttributesExW;


%{
// @pyswig None|SetFileTime|Sets the date and time that a file was created, last accessed, or last modified.
static PyObject *PySetFileTime (PyObject *self, PyObject *args)
{
	PyObject *obHandle;       // @pyparm <o PyHANDLE>/int|handle||Previously opened handle (opened with GENERIC_WRITE access).
	PyObject *obTimeCreated;  // @pyparm <o PyTime>|CreatedTime||File created time. None for no change.
	PyObject *obTimeAccessed; // @pyparm <o PyTime>|AccessTime||File access time. None for no change.
	PyObject *obTimeWritten;  // @pyparm <o PyTime>|WrittenTime||File written time. None for no change.
	HANDLE hHandle;
	FILETIME TimeCreated, *lpTimeCreated;
	FILETIME TimeAccessed, *lpTimeAccessed;
	FILETIME TimeWritten, *lpTimeWritten;
	FILETIME LocalFileTime;
	
	if (!PyArg_ParseTuple(args, "OOOO:SetFileTime",
		&obHandle, &obTimeCreated, &obTimeAccessed, &obTimeWritten))
		return NULL;

    if (!PyWinObject_AsHANDLE(obHandle, &hHandle))
        return NULL;
	if (obTimeCreated == Py_None)
		lpTimeCreated= NULL;
	else
	{
		if (!PyWinObject_AsFILETIME(obTimeCreated, &LocalFileTime))
			return NULL;
		LocalFileTimeToFileTime(&LocalFileTime, &TimeCreated);
		lpTimeCreated= &TimeCreated;
	}
	if (obTimeAccessed == Py_None)
		lpTimeAccessed= NULL;
	else
	{
		if (!PyWinObject_AsFILETIME(obTimeAccessed, &LocalFileTime))
			return NULL;
		LocalFileTimeToFileTime(&LocalFileTime, &TimeAccessed);
		lpTimeAccessed= &TimeAccessed;
	}
	if (obTimeWritten == Py_None)
		lpTimeWritten= NULL;
	else
	{
		if (!PyWinObject_AsFILETIME(obTimeWritten, &LocalFileTime))
			return NULL;
		LocalFileTimeToFileTime(&LocalFileTime, &TimeWritten);
		lpTimeWritten= &TimeWritten;
	}
	if (!::SetFileTime(hHandle, lpTimeCreated, lpTimeAccessed, lpTimeWritten))
		return PyWin_SetAPIError("SetFileTime");
	Py_INCREF(Py_None);
	return Py_None;
}
%}
%native(SetFileTime) PySetFileTime;

%{
// @pyswig tuple|GetFileInformationByHandle|Retrieves file information for a specified file. 
static PyObject *PyGetFileInformationByHandle(PyObject *self, PyObject *args)
{
	PyObject *obHandle;
	BOOL rc;
	BY_HANDLE_FILE_INFORMATION fi;
	// @pyparm <o PyHANDLE>/int|handle||Handle to the file for which to obtain information.<nl>This handle should not be a pipe handle. The GetFileInformationByHandle function does not work with pipe handles.
	if (!PyArg_ParseTuple(args, "O", &obHandle))
		return NULL;
	HANDLE handle;
	if (!PyWinObject_AsHANDLE(obHandle, &handle))
		return NULL;
	Py_BEGIN_ALLOW_THREADS
	memset(&fi, 0, sizeof(fi));
	rc = GetFileInformationByHandle(handle, &fi);
	Py_END_ALLOW_THREADS
	if (!rc)
		return PyWin_SetAPIError("GetFileInformationByHandle");
	// @rdesc The result is a tuple of:
	return Py_BuildValue("iNNNiiiiii",
		fi.dwFileAttributes, // @tupleitem 0|int|dwFileAttributes|
		PyWinObject_FromFILETIME(fi.ftCreationTime), // @tupleitem 1|<o PyTime>|ftCreationTime|
		PyWinObject_FromFILETIME(fi.ftLastAccessTime),// @tupleitem 2|<o PyTime>|ftLastAccessTime|
		PyWinObject_FromFILETIME(fi.ftLastWriteTime),// @tupleitem 3|<o PyTime>|ftLastWriteTime|
		fi.dwVolumeSerialNumber,// @tupleitem 4|int|dwVolumeSerialNumber|
		fi.nFileSizeHigh,// @tupleitem 5|int|nFileSizeHigh|
		fi.nFileSizeLow,// @tupleitem 6|int|nFileSizeLow|
		fi.nNumberOfLinks,// @tupleitem 7|int|nNumberOfLinks|
		fi.nFileIndexHigh,// @tupleitem 8|int|nFileIndexHigh|
		fi.nFileIndexLow);// @tupleitem 9|int|nFileIndexLow|
	// @comm Depending on the underlying network components of the operating system and the type of server 
	// connected to, the GetFileInformationByHandle function may fail, return partial information, 
	// or full information for the given file. In general, you should not use GetFileInformationByHandle 
	// unless your application is intended to be run on a limited set of operating system configurations.
}

%}
%native(GetFileInformationByHandle) PyGetFileInformationByHandle;



//GetFileAttributesEx	


#ifndef MS_WINCE
%{
PyObject *MyGetCompressedFileSize(PyObject *self, PyObject *args)
{
	PyObject *obName;
	TCHAR *fname;
	if (!PyArg_ParseTuple(args, "O", &obName))
		return NULL;
	if (!PyWinObject_AsTCHAR(obName, &fname, FALSE))
		return NULL;
	DWORD dwSizeLow, dwSizeHigh;
    Py_BEGIN_ALLOW_THREADS
	dwSizeLow = GetCompressedFileSize(fname, &dwSizeHigh);
    Py_END_ALLOW_THREADS
	// If we failed ... 
	if (dwSizeLow == 0xFFFFFFFF && 
	    GetLastError() != NO_ERROR )
		return PyWin_SetAPIError("GetCompressedFileSize");
	return PyLong_FromTwoInts(dwSizeHigh, dwSizeLow);
}
%}
// @pyswig <o PyLARGE_INTEGER>|GetCompressedFileSize|Determines the compressed size of a file.
%native(GetCompressedFileSize) MyGetCompressedFileSize;

#endif
%{
PyObject *MyGetFileSize(PyObject *self, PyObject *args)
{
	PyObject *obHandle;
	if (!PyArg_ParseTuple(args, "O", &obHandle))
		return NULL;
	HANDLE hFile;
	if (!PyWinObject_AsHANDLE(obHandle, &hFile))
		return NULL;
	DWORD dwSizeLow=0, dwSizeHigh=0;
    Py_BEGIN_ALLOW_THREADS
	dwSizeLow = GetFileSize (hFile, &dwSizeHigh);
    Py_END_ALLOW_THREADS
	// If we failed ... 
	if (dwSizeLow == 0xFFFFFFFF && 
	    GetLastError() != NO_ERROR )
		return PyWin_SetAPIError("GetFileSize");
	return PyLong_FromTwoInts(dwSizeHigh, dwSizeLow);
}

%}
// @pyswig <o PyLARGE_INTEGER>|GetFileSize|Determines the size of a file.
%native(GetFileSize) MyGetFileSize;

// @object PyOVERLAPPEDReadBuffer|An alias for a standard Python buffer object.
// Previous versions of the Windows extensions had a custom object for
// holding a read buffer.  This has been replaced with the standard Python buffer object.
// <nl>Python does not provide a method for creating a read-write buffer
// of arbitary size, so currently this can only be created by <om win32file.AllocateReadBuffer>.
#ifndef MS_WINCE
%{
// @pyswig <o PyOVERLAPPEDReadBuffer>|AllocateReadBuffer|Allocated a buffer which can be used with an overlapped Read operation using <om win32file.ReadFile>
PyObject *MyAllocateReadBuffer(PyObject *self, PyObject *args)
{
	int bufSize;
	// @pyparm int|bufSize||The size of the buffer to allocate.
	if (!PyArg_ParseTuple(args, "i", &bufSize))
		return NULL;
	return PyBuffer_New(bufSize);
}
%}

%native(AllocateReadBuffer) MyAllocateReadBuffer;
#endif

%{
// @pyswig (int, string)|ReadFile|Reads a string from a file
// @rdesc The result is a tuple of (hr, string/<o PyOVERLAPPEDReadBuffer>), where hr may be 
// 0, ERROR_MORE_DATA or ERROR_IO_PENDING.
// If the overlapped param is not None, then the result is a <o PyOVERLAPPEDReadBuffer>.  Once the overlapped IO operation
// has completed, you can convert this to a string (str(object))to obtain the data.
// While the operation is in progress, you can use the slice operations (object[:end]) to
// obtain the data read so far.
// You must use the OVERLAPPED API functions to determine how much of the data is valid.
PyObject *MyReadFile(PyObject *self, PyObject *args)
{
	OVERLAPPED *pOverlapped;
	PyObject *obhFile;
	HANDLE hFile;
	DWORD bufSize;
	PyObject *obOverlapped = NULL;
	BOOL bBufMallocd = FALSE;
	PyObject *obBuf;

	if (!PyArg_ParseTuple(args, "OO|O:ReadFile", 
		&obhFile, // @pyparm <o PyHANDLE>/int|hFile||Handle to the file
		&obBuf, // @pyparm <o PyOVERLAPPEDReadBuffer>/int|buffer/bufSize||Size of the buffer to create for the read.  If a multi-threaded overlapped operation is performed, a buffer object can be passed.  If a buffer object is passed, the result is the buffer itself.
		&obOverlapped))	// @pyparm <o PyOVERLAPPED>|ol|None|An overlapped structure
		return NULL;
	// @comm in a multi-threaded overlapped environment, it is likely to be necessary to pre-allocate the read buffer using the <om win32file.AllocateReadBuffer> method, otherwise the I/O operation may complete before you can assign to the resulting buffer.
	if (obOverlapped==NULL)
		pOverlapped = NULL;
	else {
		if (!PyWinObject_AsOVERLAPPED(obOverlapped, &pOverlapped))
			return NULL;
	}
	if (!PyWinObject_AsHANDLE(obhFile, &hFile))
		return NULL;

	void *buf = NULL;
	PyObject *pORB = NULL;
	PyBufferProcs *pb = NULL;

	if (PyInt_Check(obBuf)) {
		bufSize = PyInt_AsLong(obBuf);
#ifndef MS_WINCE
		if (pOverlapped) {
			pORB = PyBuffer_New(bufSize);
			if (pORB==NULL) {
				PyErr_SetString(PyExc_MemoryError, "Allocating read buffer");
				return NULL;
			}
			pb = pORB->ob_type->tp_as_buffer;
			(*pb->bf_getreadbuffer)(pORB, 0, &buf);
		} else {
#endif
			buf = malloc(bufSize);
			bBufMallocd = TRUE;
#ifndef MS_WINCE
		}
#endif
		if (buf==NULL) {
			PyErr_SetString(PyExc_MemoryError, "Allocating read buffer");
			return NULL;
		}
	} 
#ifndef MS_WINCE
	else if (obBuf->ob_type->tp_as_buffer){
		pb = obBuf->ob_type->tp_as_buffer;
		pORB = obBuf;
		Py_INCREF(pORB);
		bufSize = (*pb->bf_getreadbuffer)(pORB, 0, &buf);
	}
#endif // MS_WINCE
	 else {
		PyErr_SetString(PyExc_TypeError, "Second param must be an integer or a buffer object");
		return NULL;
	}

	DWORD numRead;
	BOOL ok;
    Py_BEGIN_ALLOW_THREADS
	ok = ReadFile(hFile, buf, bufSize, &numRead, pOverlapped);
    Py_END_ALLOW_THREADS
	DWORD err = 0;
	if (!ok) {
		err = GetLastError();
		if (err!=ERROR_MORE_DATA && err != ERROR_IO_PENDING) {
			Py_XDECREF(pORB);
			if (bBufMallocd)
				free(buf);
			return PyWin_SetAPIError("ReadFile", err);
		}
	}
	PyObject *obRet;
	if (pOverlapped)
		obRet = pORB;
	else
		obRet = PyString_FromStringAndSize((char *)buf, numRead);

	PyObject *result = Py_BuildValue("iO", err, obRet);
	Py_XDECREF(obRet);
	if (bBufMallocd)
		free(buf);
	return result;
}

// @pyswig int, int|WriteFile|Writes a string to a file
// @rdesc The result is a tuple of (errCode, nBytesWritten).  If errCode is not zero,
// it will be ERROR_IO_PENDING (ie, it is an overlapped request).
// <nl>Any other error will raise an exception.
// @comm If you use an overlapped buffer, then it is your responsibility
// to ensure the string object passed remains valid until the operation
// completes.  If Python garbage collection reclaims the buffer before the
// win32 API has finished with it, the results are unpredictable.
PyObject *MyWriteFile(PyObject *self, PyObject *args)
{
	OVERLAPPED *pOverlapped;
	PyObject *obhFile;
	HANDLE hFile;
	char *writeData;
	DWORD writeSize;
	PyObject *obWriteData;
	PyObject *obOverlapped = NULL;
	PyBufferProcs *pb = NULL;

	if (!PyArg_ParseTuple(args, "OO|O:WriteFile", 
		&obhFile, // @pyparm <o PyHANDLE>/int|hFile||Handle to the file
		&obWriteData, // @pyparm string/<o PyOVERLAPPEDReadBuffer>|data||The data to write.
		&obOverlapped))	// @pyparm <o PyOVERLAPPED>|ol|None|An overlapped structure
		return NULL;
	if (PyString_Check(obWriteData)) {
		writeData = PyString_AsString(obWriteData);
		writeSize = PyString_Size(obWriteData);
	} 
#ifndef MS_WINCE
	else if (obWriteData->ob_type->tp_as_buffer) {
		pb = obWriteData->ob_type->tp_as_buffer;
		writeSize = (*pb->bf_getreadbuffer)(obWriteData, 0, (void **)&writeData);
	} 
#endif // MS_WINCE
	else {
		return PyErr_Format(PyExc_TypeError, "Objects of type '%s' can not be directly written to a file", obWriteData->ob_type->tp_name);
	}
	if (obOverlapped==NULL)
		pOverlapped = NULL;
	else {
		if (!PyWinObject_AsOVERLAPPED(obOverlapped, &pOverlapped))
			return NULL;
	}
	if (!PyWinObject_AsHANDLE(obhFile, &hFile))
		return NULL;
	DWORD numWritten;
	BOOL ok;
	DWORD err = 0;
    Py_BEGIN_ALLOW_THREADS
	ok = WriteFile(hFile, writeData, writeSize, &numWritten, pOverlapped);
    Py_END_ALLOW_THREADS
	if (!ok) {
		err = GetLastError();
		if (err != ERROR_IO_PENDING)
			return PyWin_SetAPIError("WriteFile");
	}
	return Py_BuildValue("ll", err, numWritten);
}

// @pyswig |CloseHandle|Closes an open handle.
static PyObject *MyCloseHandle(PyObject *self, PyObject *args)
{
	PyObject *obHandle;
	if (!PyArg_ParseTuple(args, "O:CloseHandle",
			&obHandle)) // @pyparm <o PyHANDLE>/int|handle||A previously opened handle.
		return NULL;
	if (!PyWinObject_CloseHANDLE(obHandle))
		return NULL;
	Py_INCREF(Py_None);
	return Py_None;
}

#ifndef MS_WINCE
// @pyswig |LockFileEx|Locks a file. Wrapper for LockFileEx win32 API.
static PyObject *
MyLockFileEx(PyObject *self, PyObject *args)
{
	OVERLAPPED *pOverlapped;
	PyObject *obhFile;
	HANDLE hFile;
	PyObject *obOverlapped = NULL;
    DWORD dwFlags, nbytesLow, nbytesHigh;

	if (!PyArg_ParseTuple(args, "OiiiO:LockFileEx", 
		&obhFile, // @pyparm <o PyHANDLE>/int|hFile||Handle to the file
        &dwFlags, // @pyparm dwFlags|int||Flags that specify exclusive/shared and blocking/non-blocking mode
        &nbytesLow, // @pyparm nbytesLow|int||low-order part of number of bytes to lock
        &nbytesHigh, // @pyparm nbytesHigh|int||high-order part of number of bytes to lock
		&obOverlapped))	// @pyparm <o PyOVERLAPPED>|ol|None|An overlapped structure
		return NULL;
	if (obOverlapped==NULL)
		pOverlapped = NULL;
	else {
		if (!PyWinObject_AsOVERLAPPED(obOverlapped, &pOverlapped))
			return NULL;
	}
	if (!PyWinObject_AsHANDLE(obhFile, &hFile))
		return NULL;

	BOOL ok;
	DWORD err = 0;
    Py_BEGIN_ALLOW_THREADS
	ok = LockFileEx(hFile, dwFlags, 0, nbytesLow, nbytesHigh, pOverlapped);
    Py_END_ALLOW_THREADS

	if (ok == 0) {
		err = GetLastError();
		return PyWin_SetAPIError("LockFileEx", err);
	}

    Py_INCREF(Py_None);
    return Py_None;
}

// @pyswig |UnlockFileEx|Unlocks a file. Wrapper for UnlockFileEx win32 API.
static PyObject *
MyUnlockFileEx(PyObject *self, PyObject *args)
{
    OVERLAPPED *pOverlapped;
    PyObject *obhFile;
    HANDLE hFile;
    PyObject *obOverlapped = NULL;
    DWORD nbytesLow, nbytesHigh;

    if (!PyArg_ParseTuple(args, "OiiO:UnlockFileEx", 
        &obhFile, // @pyparm <o PyHANDLE>/int|hFile||Handle to the file
        &nbytesLow, // @pyparm nbytesLow|int||low-order part of number of
                    // bytes to lock
        &nbytesHigh, // @pyparm nbytesLow|int||high-order part of number of
                     // bytes to lock
        &obOverlapped))	// @pyparm <o PyOVERLAPPED>|ol|None|An overlapped structure
        return NULL;
    if (obOverlapped==NULL)
        pOverlapped = NULL;
    else {
        if (!PyWinObject_AsOVERLAPPED(obOverlapped, &pOverlapped))
            return NULL;
    }
    if (!PyWinObject_AsHANDLE(obhFile, &hFile))
        return NULL;

    BOOL ok;
    DWORD err = 0;

    Py_BEGIN_ALLOW_THREADS
    ok = UnlockFileEx(hFile, 0, nbytesLow, nbytesHigh, pOverlapped);
    Py_END_ALLOW_THREADS

    if (ok == 0) {
        err = GetLastError();
        return PyWin_SetAPIError("UnlockFileEx", err);
    }
    Py_INCREF(Py_None);
    return Py_None;
}

#endif // MS_WINCE
%}

#ifndef MS_WINCE
%{

// See Q192800 for an interesting discussion on overlapped and IOCP.

PyObject *PyWinObject_FromQueuedOVERLAPPED(OVERLAPPED *p)
{
	if (p==NULL || p==(OVERLAPPED *)-1) {
		Py_INCREF(Py_None);
		return Py_None;
	}

	// We know this is a pointer to an OVERLAPPED inside a PyObject
	// extract it back out.
	size_t off = offsetof(PyOVERLAPPED, m_overlapped);
	PyOVERLAPPED *po = (PyOVERLAPPED *)(((LPBYTE)p) - off);
	// Hope like hell it hasn't already died on us (PostQueuedCompletionStatus
	// makes it impossible it has died, but other functions do not as they
	// don't know if the OVERLAPPED will end up in a IOCP)
	// Also check it is a valid write pointer (we don't write to it, but all
	// PyObjects are writable, so that extra check is worthwhile)
	// This is NOT foolproof - screw up reference counting and things may die!
	if (po->ob_refcnt<=0 || po->ob_type==0 || IsBadWritePtr(po, sizeof(PyOVERLAPPED))) {
		PyErr_SetString(PyExc_RuntimeError, "This overlapped object has lost all its references so was destroyed");
		return NULL;
	}
	// consume reference added when it was posted, if added.
	if (po->m_overlapped.isArtificialReference)
		po->m_overlapped.isArtificialReference = FALSE;
	else
		// Overlapped we didn't actually queue so no artificial refcount
		Py_INCREF(po);
	return po;
}

BOOL PyWinObject_AsQueuedOVERLAPPED(PyObject *ob, OVERLAPPED **ppOverlapped, BOOL bNoneOK = TRUE)
{
	PyOVERLAPPED *po = NULL;
	if (!PyWinObject_AsPyOVERLAPPED(ob, &po, bNoneOK))
		return FALSE;
	if (bNoneOK && po==NULL) {
		*ppOverlapped = NULL;
		return TRUE;
	}
	assert(po);
	if (!po)
		return FALSE;
	
	PyOVERLAPPED *pO = (PyOVERLAPPED *)po;
	// Add a fake reference so the object lives while in the queue, and add the flag
	Py_INCREF(ob);
	pO->m_overlapped.isArtificialReference = TRUE;
	*ppOverlapped = po->GetOverlapped();
	return TRUE;
}

// @pyswig (int, int, int, <o PyOVERLAPPED>)|GetQueuedCompletionStatus|Attempts to dequeue an I/O completion packet from a specified input/output completion port.
// @comm This method never throws an API error.
// <nl>The result is a tuple of (rc, numberOfBytesTransferred, completionKey, overlapped)
// <nl>If the function succeeds, rc will be set to 0, otherwise it will be set to the win32 error code.
static PyObject *myGetQueuedCompletionStatus(PyObject *self, PyObject *args)
{
	PyObject *obHandle;
	DWORD timeout;
	// @pyparm <o PyHANDLE>|hPort||The handle to the completion port.
	// @pyparm int|timeOut||Timeout in milli-seconds.
	if (!PyArg_ParseTuple(args, "Ol", &obHandle, &timeout))
		return NULL;
	HANDLE handle;
	if (!PyWinObject_AsHANDLE(obHandle, &handle, FALSE))
		return NULL;
	DWORD bytes = 0, key = 0;
	OVERLAPPED *pOverlapped = NULL;
	UINT errCode;
	Py_BEGIN_ALLOW_THREADS
	BOOL ok = GetQueuedCompletionStatus(handle, &bytes, &key, &pOverlapped, timeout);
	errCode = ok ? 0 : GetLastError();
	Py_END_ALLOW_THREADS
	PyObject *obOverlapped = PyWinObject_FromQueuedOVERLAPPED(pOverlapped);
	PyObject *rc = Py_BuildValue("illO", errCode, bytes, key, obOverlapped);
	Py_XDECREF(obOverlapped);
	return rc;
}

// @pyswig None|PostQueuedCompletionStatus|lets you post an I/O completion packet to an I/O completion port. The I/O completion packet will satisfy an outstanding call to the GetQueuedCompletionStatus function.
PyObject *myPostQueuedCompletionStatus(PyObject *self, PyObject *args)
{
	PyObject *obHandle, *obOverlapped = NULL;
	DWORD bytesTransfered = 0, key = 0;
	// @pyparm <o PyHANDLE>|handle||handle to an I/O completion port
	// @pyparm int|numberOfbytes|0|value to return via GetQueuedCompletionStatus' first result
	// @pyparm int|completionKey|0|value to return via GetQueuedCompletionStatus' second result
	// @pyparm <o PyOVERLAPPED>|overlapped|None|value to return via GetQueuedCompletionStatus' third result
	if (!PyArg_ParseTuple(args, "O|iiO", &obHandle, &bytesTransfered, &key, &obOverlapped))
		return NULL;
	HANDLE handle;
	if (!PyWinObject_AsHANDLE(obHandle, &handle, FALSE))
		return NULL;
	OVERLAPPED *pOverlapped;
	if (!PyWinObject_AsQueuedOVERLAPPED(obOverlapped, &pOverlapped, TRUE))
		return NULL;
	BOOL ok;
	Py_BEGIN_ALLOW_THREADS
	ok = ::PostQueuedCompletionStatus(handle, bytesTransfered, key, pOverlapped);
	Py_END_ALLOW_THREADS
	if (!ok)
		return PyWin_SetAPIError("PostQueuedCompletionStatus");
	Py_INCREF(Py_None);
	return Py_None;
	// @comm Note that if you post overlapped objects, but your post is closed
	// before all pending requests are processed, the overlapped objects
	// (including its 'handle' and 'object' members) will leak.
	// See MS KB article Q192800 for a summary of this.
}

%}

%native (GetQueuedCompletionStatus) myGetQueuedCompletionStatus;
%native (PostQueuedCompletionStatus) myPostQueuedCompletionStatus;
#endif // MS_WINCE

%native(ReadFile) MyReadFile;
%native(WriteFile) MyWriteFile;
%native(CloseHandle) MyCloseHandle;

#ifndef MS_WINCE
// @pyswig int|GetFileType|Determines the type of a file.
unsigned long GetFileType( // DWORD
    PyHANDLE hFile // @pyparm <o PyHANDLE>|hFile||The handle to the file.
);
#define FILE_TYPE_UNKNOWN FILE_TYPE_UNKNOWN // The type of the specified file is unknown.
#define FILE_TYPE_DISK FILE_TYPE_DISK // The specified file is a disk file.
#define FILE_TYPE_CHAR FILE_TYPE_CHAR // The specified file is a character file, typically an LPT device or a console.
#define FILE_TYPE_PIPE FILE_TYPE_PIPE // The specified file is either a named or anonymous pipe.
 
#endif // MS_WINCE

// GetFullPathName	
// @pyswig str/unicode|GetFullPathName|Returns full path for path passed in
// @comm This function takes either a plain string or a unicode string, and returns the same type
//       If unicode is passed in, GetFullPathNameW is called, which supports filenames longer than MAX_PATH
%native(GetFullPathName) MyGetFullPathName;
%{
static PyObject *MyGetFullPathName(PyObject *self, PyObject *args)
{
	PyObject *ret=NULL, *obpathin;
	int pathlen, retlen;

	// @pyparm str/unicode|FileName||Path on which to operate
	if (!PyArg_ParseTuple(args, "O", &obpathin))
		return NULL;
	WCHAR *wpathin;
	if (wpathin=PyUnicode_AsUnicode(obpathin)){
		WCHAR *wpathret, *wfilepart;
		pathlen=wcslen(wpathin)+1;
		wpathret=(WCHAR *)malloc(pathlen*sizeof(WCHAR));
		if (wpathret==NULL){
			PyErr_SetString(PyExc_MemoryError,"GetFullPathNameW: unable to allocate unicode return buffer");
			return NULL;
			}
		Py_BEGIN_ALLOW_THREADS
		retlen=GetFullPathNameW(wpathin, pathlen, wpathret, &wfilepart);
		Py_END_ALLOW_THREADS
		if (retlen>pathlen){
			pathlen=retlen;
			wpathret=(WCHAR *)realloc(wpathret,pathlen*sizeof(WCHAR));
			if (wpathret==NULL){
				PyErr_SetString(PyExc_MemoryError,"GetFullPathNameW: unable to allocate unicode return buffer");
				return NULL;
				}
			Py_BEGIN_ALLOW_THREADS
			retlen=GetFullPathNameW(wpathin, retlen, wpathret, &wfilepart);
			Py_END_ALLOW_THREADS
			}
		if (retlen>pathlen)
			PyErr_SetString(PyExc_SystemError,"GetFullPathNameW: Unexpected second increase in required buffer size");
		else
			if (retlen==0)
				PyWin_SetAPIError("GetFullPathNameW", GetLastError());
			else
				ret=PyUnicode_FromWideChar(wpathret,retlen);
		free(wpathret);
		return ret;
		}

	PyErr_Clear();
	char *cpathin;
	if (PyString_AsStringAndSize(obpathin, &cpathin, &pathlen)!=-1){
		char *cpathret, *cfilepart;
		pathlen+=1;
		cpathret=(char *)malloc(pathlen);
		if (cpathret==NULL){
			PyErr_SetString(PyExc_MemoryError,"GetFullPathName: unable to allocate character return buffer");
			return NULL;
			}
		Py_BEGIN_ALLOW_THREADS
		retlen=GetFullPathName(cpathin, pathlen, cpathret, &cfilepart);
		Py_END_ALLOW_THREADS
		if (retlen>pathlen){
			pathlen=retlen;
			cpathret=(char *)realloc(cpathret,pathlen);
			if (cpathret==NULL){
				PyErr_SetString(PyExc_MemoryError,"GetFullPathName: unable to allocate character return buffer");
				return NULL;
				}
			Py_BEGIN_ALLOW_THREADS
			retlen=GetFullPathName(cpathin, retlen, cpathret, &cfilepart);
			Py_END_ALLOW_THREADS
			}
		if (retlen>pathlen)
			PyErr_SetString(PyExc_SystemError,"GetFullPathName: Unexpected second increase in required buffer size");
		else
			if (retlen==0)
				PyWin_SetAPIError("GetFullPathName", GetLastError());
			else
				ret=PyString_FromStringAndSize(cpathret,retlen);
		free(cpathret);
		}
	return ret;
}
%}


#ifndef MS_WINCE
// @pyswig int|GetLogicalDrives|Returns a bitmaks of the logical drives installed.
unsigned long GetLogicalDrives( // DWORD
);

#endif // MS_WINCE
/**
GetLogicalDriveStrings	
GetShortPathName	
GetTempFileName	
GetTempPath	
GetVolumeInformation	
*/

#ifndef MS_WINCE
// @pyswig int|GetOverlappedResult|Determines the result of the most recent call with an OVERLAPPED object.
// @comm The result is the number of bytes transferred.  The overlapped object's attributes will be changed during this call.
BOOLAPI GetOverlappedResult(
	PyHANDLE hFile, 	// @pyparm <o PyHANDLE>|hFile||The handle to the pipe or file
	OVERLAPPED *lpOverlapped, // @pyparm <o PyOVERLAPPED>|overlapped||The overlapped object to check.
	unsigned long *OUTPUT, // lpNumberOfBytesTransferred
	BOOL bWait	// @pyparm int|bWait||Indicates if the function should wait for data to become available.
);

#endif // MS_WINCE

#ifndef MS_WINCE
// @pyswig |LockFile|Locks a specified file for exclusive access by the calling process.
BOOLAPI LockFile(
    PyHANDLE hFile,	// @pyparm <o PyHANDLE>|hFile||handle of file to lock 
    DWORD dwFileOffsetLow,	// @pyparm int|offsetLow||low-order word of lock region offset 
    DWORD dwFileOffsetHigh,	// @pyparm int|offsetHigh||high-order word of lock region offset  
    DWORD nNumberOfBytesToLockLow,	// @pyparm int|nNumberOfBytesToLockLow||low-order word of length to lock 
    DWORD nNumberOfBytesToLockHigh 	// @pyparm int|nNumberOfBytesToLockHigh||high-order word of length to lock 
   );

%native(LockFileEx) MyLockFileEx;

#endif // MS_WINCE


// @pyswig |MoveFile|Renames an existing file or a directory (including all its children). 
BOOLAPI MoveFile(
    TCHAR *lpExistingFileName,	// @pyparm <o PyUnicode>|existingFileName||Name of the existing file  
    TCHAR *lpNewFileName 	// @pyparm <o PyUnicode>|newFileName||New name for the file 
);
// @pyswig |MoveFileW|Renames an existing file or a directory (including all its children). (NT/2000 Unicode specific version).
BOOLAPI MoveFileW(
    WCHAR *lpExistingFileName,	// @pyparm <o PyUnicode>|existingFileName||Name of the existing file  
    WCHAR *lpNewFileName 	// @pyparm <o PyUnicode>|newFileName||New name for the file 
);

#ifndef MS_WINCE
// @pyswig |MoveFileEx|Renames an existing file or a directory (including all its children). 
BOOLAPI MoveFileEx(
    TCHAR *lpExistingFileName,	// @pyparm <o PyUnicode>|existingFileName||Name of the existing file  
    TCHAR *INPUT_NULLOK, 	// @pyparm <o PyUnicode>|newFileName||New name for the file, can be None for delayed delete operation
    DWORD dwFlags 	        // @pyparm int|flags||flag to determine how to move file (win32file.MOVEFILE_*)
);
// @pyswig |MoveFileExW|Renames an existing file or a directory (including all its children). (NT/2000 Unicode specific version).
BOOLAPI MoveFileExW(
    WCHAR *lpExistingFileName,	// @pyparm <o PyUnicode>|existingFileName||Name of the existing file  
    WCHAR *INPUT_NULLOK, 	// @pyparm <o PyUnicode>|newFileName||New name for the file, can be None for delayed delete operation
    DWORD dwFlags 	        // @pyparm int|flags||flag to determine how to move file (win32file.MOVEFILE_*)
);
#define MOVEFILE_COPY_ALLOWED MOVEFILE_COPY_ALLOWED // If the file is to be moved to a different volume, the function simulates the move by using the CopyFile and DeleteFile functions. Cannot be combined with the MOVEFILE_DELAY_UNTIL_REBOOT flag.
#define MOVEFILE_DELAY_UNTIL_REBOOT MOVEFILE_DELAY_UNTIL_REBOOT // Windows NT only: The function does not move the file until the operating system is restarted. The system moves the file immediately after AUTOCHK is executed, but before creating any paging files. Consequently, this parameter enables the function to delete paging files from previous startups.
#define MOVEFILE_REPLACE_EXISTING MOVEFILE_REPLACE_EXISTING // If a file of the name specified by lpNewFileName already exists, the function replaces its contents with those specified by lpExistingFileName.
#define MOVEFILE_WRITE_THROUGH MOVEFILE_WRITE_THROUGH // Windows NT only: The function does not return until the file has actually been moved on the disk. Setting this flag guarantees that a move perfomed as a copy and delete operation is flushed to disk before the function returns. The flush occurs at the end of the copy operation.<nl>This flag has no effect if the MOVEFILE_DELAY_UNTIL_REBOOT flag is set. 
#define MOVEFILE_CREATE_HARDLINK MOVEFILE_CREATE_HARDLINK
#define MOVEFILE_FAIL_IF_NOT_TRACKABLE MOVEFILE_FAIL_IF_NOT_TRACKABLE

#endif // MS_WINCE

// @pyswig string|QueryDosDevice|Returns the mapping for a device name, or all device names
%native (QueryDosDevice) MyQueryDosDevice;
%{
static PyObject *MyQueryDosDevice(PyObject *self, PyObject *args)
{
	PyObject *ret=NULL;
	char *devicename, *targetpath=NULL;
	DWORD retlen, buflen, err;
	// @pyparm string|DeviceName||Name of device to query, or None to return all defined devices
	// @rdesc Returns a string containing substrings separated by NULLs with 2 terminating NULLs
	if (!PyArg_ParseTuple(args, "z:QueryDosDevice", &devicename))
		return NULL;
	if (devicename==NULL)	// this returns a huge string
		buflen=8192;	
	else
		buflen=256;
	// function returns ERROR_INSUFFICIENT_BUFFER with no indication of how much memory is actually needed
	while (true){
		if (targetpath){
			free(targetpath);
			buflen*=2;
			}
		targetpath=(char *)malloc(buflen);
		if (targetpath==NULL)
			return PyErr_Format(PyExc_MemoryError, "Unable to allocate %d bytes", buflen);
		retlen=QueryDosDevice(devicename, targetpath, buflen);
		if (retlen!=0){
			ret=PyString_FromStringAndSize(targetpath, retlen);
			break;
			}
		err=GetLastError();
		if (err!=ERROR_INSUFFICIENT_BUFFER){
			PyWin_SetAPIError("QueryDosDevice",err);
			break;
			}
		}
	if (targetpath)
		free(targetpath);
	return ret;
}
%}

%{
static PyObject *PyObject_FromFILE_NOTIFY_INFORMATION(void *buffer, DWORD nbytes)
{
	FILE_NOTIFY_INFORMATION *p = (FILE_NOTIFY_INFORMATION *)buffer;
	PyObject *ret = PyList_New(0);
	if (nbytes < sizeof FILE_NOTIFY_INFORMATION)
		return ret;
	DWORD nbytes_read = 0;
	while (1) {
		PyObject *fname = PyWinObject_FromOLECHAR(p->FileName, p->FileNameLength/sizeof WCHAR);
		if (!fname) {
			Py_DECREF(ret);
			return NULL;
		}
		PyObject *ob = Py_BuildValue("iN", p->Action, fname);
		if (ob==NULL) {
			Py_DECREF(ret);
			return NULL;
		}
		PyList_Append(ret, ob);
		Py_DECREF(ob);
		if (p->NextEntryOffset==0)
			break;
		p = (FILE_NOTIFY_INFORMATION *)(((BYTE *)p) + p->NextEntryOffset);
		nbytes_read += p->NextEntryOffset;
		if (nbytes_read > nbytes) {
			PyErr_SetString(PyExc_RuntimeError, "internal error decoding - running off end of buffer before seeing end-of-buffer marker");
			Py_DECREF(ret);
			return NULL;
		}
	 }
	 return ret;
}

// @pyswig |ReadDirectoryChangesW|retrieves information describing the changes occurring within a directory.
static PyObject *PyReadDirectoryChangesW(PyObject *self, PyObject *args)
{
	BOOL ok;
	HANDLE handle;
	BOOL bWatchSubtree;
	DWORD filter;
	DWORD bytes_returned;
	PyObject *obBuffer;
	PyObject *ret = NULL;
	PyObject *obOverlapped = Py_None;
	PyObject *obOverlappedRoutine = Py_None;
	if (!PyArg_ParseTuple(args, "iOii|OO",
	                      &handle, // @pyparm int|handle||Handle to the directory to be monitored. This directory must be opened with the FILE_LIST_DIRECTORY access right.
	                      &obBuffer, // @pyparm int|size||Size of the buffer to allocate for the results.
	                      &bWatchSubtree, // @pyparm int|bWatchSubtree||Specifies whether the ReadDirectoryChangesW function will monitor the directory or the directory tree. If TRUE is specified, the function monitors the directory tree rooted at the specified directory. If FALSE is specified, the function monitors only the directory specified by the hDirectory parameter.
	                      &filter, // @pyparm int|dwNotifyFilter||Specifies filter criteria the function checks to determine if the wait operation has completed. This parameter can be one or more of the FILE_NOTIFY_CHANGE_* values.
	                      &obOverlapped, // @pyparm <o PyOVERLAPPED>|overlapped|None|An overlapped object.  The directory must also be opened with FILE_FLAG_OVERLAPPED.
	                      &obOverlappedRoutine))
		return NULL;

	// @comm If you pass an overlapped object, you almost certainly
	// must pass a buffer object for the asynchronous results - failure
	// to do so may crash Python as the asynchronous result writes to
	// invalid memory.
	OVERLAPPED *pOverlapped = NULL;
	if (obOverlapped && obOverlapped != Py_None)
		if (!PyWinObject_AsOVERLAPPED(obOverlapped, &pOverlapped))
			return NULL;

	// Todo: overlappedRoutine support.
	if (obOverlappedRoutine != Py_None)
		return PyErr_Format(PyExc_ValueError, "overlappedRoutine must be None");

	void *buf = NULL;
	int bufSize = 0;
	BOOL bBufMallocd = FALSE;
	if (PyInt_Check(obBuffer)) {
		bufSize = PyInt_AsLong(obBuffer);
		buf = malloc(bufSize);
		if (buf==NULL) {
			PyErr_SetString(PyExc_MemoryError, "Allocating read buffer");
			goto done;
		}
		bBufMallocd = TRUE;
	}
	else if (obBuffer->ob_type->tp_as_buffer) {
		PyBufferProcs *pb = obBuffer->ob_type->tp_as_buffer;
		bufSize = (*pb->bf_getreadbuffer)(obBuffer, 0, &buf);
	}
	 else {
		PyErr_SetString(PyExc_TypeError, "buffer param must be an integer or a buffer object");
		goto done;
	}

	// OK, have a buffer and a size.
	Py_BEGIN_ALLOW_THREADS
	ok = ::ReadDirectoryChangesW(handle, buf, bufSize, bWatchSubtree, filter, &bytes_returned, pOverlapped, NULL);
	Py_END_ALLOW_THREADS
	if (!ok) {
		return PyWin_SetAPIError("ReadDirectoryChangesW");
		goto done;
	}
	// If they passed a size, we return the buffer, already unpacked.
	if (bBufMallocd) {
		ret = PyObject_FromFILE_NOTIFY_INFORMATION(buf, bytes_returned);
	} else {
		// asynch call - bytes_returned is undefined - so just return None.
		ret = Py_None;
		Py_INCREF(Py_None);
	}
    // @rdesc If a buffer size is passed, the result is a list of (action, filename)
    // @rdesc If a buffer is passed, the result is None - you must use the overlapped
    // object to determine when the information is available and how much is valid.
    // The buffer can then be passed to <om win32file.FILE_NOTIFY_INFORMATION>
    // @comm The FILE_NOTIFY_INFORMATION structure used by this function
    // is variable length, depending on the length of the filename.
    // The size of the buffer must be at least 6 bytes long + the length
    // of the filenames returned.  The number of notifications that can be
    // returned for a given buffer size depends on the filename lengths.
done:
	if (bBufMallocd && buf)
		free(buf);
	return ret;
}

// @pyswig [(action, filename), ...|FILE_NOTIFY_INFORMATION|Decodes a PyFILE_NOTIFY_INFORMATION buffer.
PyObject *PyFILE_NOTIFY_INFORMATION(PyObject *self, PyObject *args)
{
	// @pyparm string|buffer||The buffer to decode.
	// @pyparm int|size||The number of bytes to refer to.  Generally this
	// will be smaller than the size of the buffer (and certainly never greater!)
	// @comm See <om win32file.ReadDirectoryChangesW> for more information.
	int bufSize, size;
	char *buf;
	if (!PyArg_ParseTuple(args, "s#i", &buf, &bufSize, &size))
		return NULL;
	if (size > bufSize)
		return PyErr_Format(PyExc_ValueError, "buffer is only %d bytes long, but %d bytes were requested",
		                    bufSize, size);

	return PyObject_FromFILE_NOTIFY_INFORMATION((void *)buf, size);
}

%}
%native(ReadDirectoryChangesW) PyReadDirectoryChangesW;
%native(FILE_NOTIFY_INFORMATION) PyFILE_NOTIFY_INFORMATION;

// ReadFileEx	

// @pyswig |RemoveDirectory|Removes an existing directory
%name(RemoveDirectory) BOOLAPI RemoveDirectoryW(
    WCHAR *lpPathName	// @pyparm str/<o PyUnicode>|lpPathName||Name of the path to remove.
// @comm This is implemented using RemoveDirectoryW.
);

//SearchPath	

#ifndef MS_WINCE
// @pyswig |SetCurrentDirectory|Sets the current directory.
%name(SetCurrentDirectory) BOOLAPI SetCurrentDirectoryW(
    WCHAR *lpPathName	// @pyparm str/<o PyUnicode>|lpPathName||Name of the path to set current.
);
#endif // MS_WINCE

// @pyswig |SetEndOfFile|Moves the end-of-file (EOF) position for the specified file to the current position of the file pointer. 
BOOL SetEndOfFile(
    PyHANDLE hFile	// @pyparm <o PyHANDLE>|hFile||handle of file whose EOF is to be set 
);

#ifndef MS_WINCE
// @pyswig |SetFileApisToANSI|Causes a set of Win32 file functions to use the ANSI character set code page. This function is useful for 8-bit console input and output operations.
void SetFileApisToANSI(void);

// @pyswig |SetFileApisToOEM|Causes a set of Win32 file functions to use the OEM character set code page. This function is useful for 8-bit console input and output operations.
void SetFileApisToOEM(void);
#endif

// @pyswig |SetFileAttributes|Changes a file's attributes.
BOOLAPI SetFileAttributes(
    TCHAR *lpFileName,	// @pyparm <o PyUnicode>|filename||filename 
    DWORD dwFileAttributes 	// @pyparm int|newAttributes||attributes to set 
);	

// @pyswig |SetFileAttributesW|Changes a file's attributes (NT/2000 Unicode specific version)
BOOLAPI SetFileAttributesW(
    WCHAR *lpFileName,	// @pyparm <o PyUnicode>|filename||filename 
    DWORD dwFileAttributes 	// @pyparm int|newAttributes||attributes to set 
);	
 
%{
// @pyswig |SetFilePointer|Moves the file pointer of an open file. 
PyObject *MySetFilePointer(PyObject *self, PyObject *args)
{
	PyObject *obHandle, *obOffset;
	DWORD iMethod;
	HANDLE handle;
	if (!PyArg_ParseTuple(args, "OOl", 
			&obHandle,  // @pyparm <o PyHANDLE>|handle||The file to perform the operation on.
			&obOffset, // @pyparm <o Py_LARGEINTEGER>|offset||Offset to move the file pointer.
			&iMethod)) // @pyparm int|moveMethod||Starting point for the file pointer move. This parameter can be one of the following values.
			              // @flagh Value|Meaning 
			              // @flag FILE_BEGIN|The starting point is zero or the beginning of the file. 
			              // @flag FILE_CURRENT|The starting point is the current value of the file pointer. 
			              // @flag FILE_END|The starting point is the current end-of-file position. 

		return NULL;
	if (!PyWinObject_AsHANDLE(obHandle, &handle, FALSE))
		return NULL;
	long offHigh;
	unsigned offLow;
	if (!PyLong_AsTwoInts(obOffset, (int *)&offHigh, &offLow))
		return NULL;
    Py_BEGIN_ALLOW_THREADS
	offLow = SetFilePointer(handle, offLow, &offHigh, iMethod);
    Py_END_ALLOW_THREADS
	// If we failed ... 
	if (offLow == 0xFFFFFFFF && 
	    GetLastError() != NO_ERROR )
		return PyWin_SetAPIError("SetFilePointer");
	return PyLong_FromTwoInts(offHigh, offLow);
}
%}
%native(SetFilePointer) MySetFilePointer;

#define FILE_BEGIN FILE_BEGIN
#define FILE_END FILE_END
#define FILE_CURRENT FILE_CURRENT

#ifndef MS_WINCE
// @pyswig |SetVolumeLabel|Sets a volume label for a disk drive.
BOOLAPI SetVolumeLabel(
    TCHAR *lpRootPathName,	// @pyparm <o PyUnicode>|rootPathName||address of name of root directory for volume 
    TCHAR *lpVolumeName 	// @pyparm <o PyUnicode>|volumeName||name for the volume 
   );

// @pyswig |UnlockFile|Unlocks a region of a file locked by <om win32file.LockFile> or <om win32file.LockFileEx>
BOOLAPI UnlockFile(
    PyHANDLE hFile,	// @pyparm <o PyHANDLE>|hFile||handle of file to unlock 
    DWORD dwFileOffsetLow,	// @pyparm int|offsetLow||low-order word of lock region offset 
    DWORD dwFileOffsetHigh,	// @pyparm int|offsetHigh||high-order word of lock region offset  
    DWORD nNumberOfBytesToUnlockLow,	// @pyparm int|nNumberOfBytesToUnlockLow||low-order word of length to unlock 
    DWORD nNumberOfBytesToUnlockHigh 	// @pyparm int|nNumberOfBytesToUnlockHigh||high-order word of length to unlock 
   );

%native(UnlockFileEx) MyUnlockFileEx;
#endif // MS_WINCE

// File Handle / File Descriptor APIs.
#ifndef MS_WINCE
// @pyswig long|_get_osfhandle|Gets operating-system file handle associated with existing stream
%name(_get_osfhandle)
PyObject *myget_osfhandle( int filehandle );

// @pyswig int|_open_osfhandle|Associates a C run-time file handle with a existing operating-system file handle.
%name(_open_osfhandle)
PyObject *myopen_osfhandle ( PyHANDLE osfhandle, int flags );


%{
PyObject *myget_osfhandle (int filehandle)
{
  long result = _get_osfhandle (filehandle);
  if (result == -1)
    return PyErr_SetFromErrno(PyExc_IOError);

  return Py_BuildValue ("l",result);
}

PyObject *myopen_osfhandle (PyHANDLE osfhandle, int flags)
{
  int result = _open_osfhandle ((long) osfhandle, flags);
  if (result == -1)
    return PyErr_SetFromErrno(PyExc_IOError);

  return Py_BuildValue ("i",result);
}

%}

// Overlapped Socket stuff
%{
#pragma comment(lib,"mswsock.lib") // too lazy to change the project file :-)
#pragma comment(lib,"ws2_32.lib")
%}

%native(AcceptEx) MyAcceptEx;

%native(GetAcceptExSockaddrs) MyGetAcceptExSockaddrs;

%{
// @pyswig |AcceptEx|Version of accept that uses Overlapped I/O
// @rdesc The result is 0 or ERROR_IO_PENDING.  All other values will raise
// win32file.error.  Specifically: if the win32 function returns FALSE,
// WSAGetLastError() is checked for ERROR_IO_PENDING.
static PyObject *MyAcceptEx
(
	PyObject *self,
	PyObject *args
)
{
	OVERLAPPED *pOverlapped = NULL;
	SOCKET sListening;
	SOCKET sAccepting;
	PyObject *obOverlapped = NULL;
	DWORD dwBufSize = 0;
	PyObject *rv = NULL;
	PyObject *obListening = NULL;
	PyObject *obAccepting = NULL;
	PyObject *obBuf = NULL;
	PyObject *pORB = NULL;
	void *buf = NULL;
	DWORD cBytesRecvd = 0;
	BOOL ok;
	int rc = 0;
	int iMinBufferSize = (sizeof(SOCKADDR_IN) + 16) * 2;
	WSAPROTOCOL_INFO wsProtInfo;
	UINT cbSize = sizeof(wsProtInfo);
	PyBufferProcs *pb = NULL;

	if (!PyArg_ParseTuple(
		args,
		"OOOO:AcceptEx",
		&obListening, // @pyparm <o PySocket>/int|sListening||Socket that had listen() called on.
		&obAccepting, // @pyparm <o PySocket>/int|sAccepting||Socket that will be used as the incoming connection.
		&obBuf, // @pyparm <o buffer>|buffer||Buffer to read incoming data and connection point information into. This buffer MUST be big enough to recieve your connection endpoints... AF_INET sockets need to be at least 64 bytes. The correct minimum of the buffer is determined by the protocol family that the listening socket is using.
		&obOverlapped)) // @pyparm <o PyOVERLAPPED>|ol||An overlapped structure
	{
		return NULL;
	}

	// @comm In order to make sure the connection has been accepted, either use the hEvent in PyOVERLAPPED, GetOverlappedResult, or GetQueuedCompletionStatus.
	// @comm To use this with I/O completion ports, don't forget to attach sAccepting to your completion port.
	// @comm To have sAccepting inherit the properties of sListening, you need to do the following after a connection is successfully accepted:
	// @comm import struct
	// @comm sAccepting.setsockopt(socket.SOL_SOCKET, win32file.SO_UPDATE_ACCEPT_CONTEXT, struct.pack("I", sListening.fileno()))

	if (!PySocket_AsSOCKET(obListening, &sListening))
	{
		return NULL;
	}

	// Grab the protocol information for the socket
	// So we can compute the correct minimum buffer size.
	Py_BEGIN_ALLOW_THREADS
	rc = getsockopt(
		sListening,
		SOL_SOCKET,
		SO_PROTOCOL_INFO,
		(char *)&wsProtInfo,
		(int *)&cbSize);
	Py_END_ALLOW_THREADS
	if (rc == SOCKET_ERROR)
	{
		PyWin_SetAPIError("getsockopt", WSAGetLastError());
		return NULL;
	}
	iMinBufferSize = (wsProtInfo.iMaxSockAddr + 16) * 2;

	if (!PySocket_AsSOCKET(obAccepting, &sAccepting))
	{
		return NULL;
	}

	if (!PyWinObject_AsOVERLAPPED(obOverlapped, &pOverlapped))
	{
		return NULL;
	}

	if (obBuf->ob_type->tp_as_buffer)
	{
		pORB = obBuf;
		Py_INCREF(pORB);
		pb = pORB->ob_type->tp_as_buffer;
		dwBufSize = (*pb->bf_getreadbuffer)(pORB, 0, &buf);
		if (dwBufSize < (DWORD)iMinBufferSize )
		{
			PyErr_Format(
				PyExc_ValueError,
				"Second param must be at least %ld bytes long",
				iMinBufferSize);
			goto Error;
		}
	}
	else
	{
		PyErr_SetString(PyExc_TypeError, "Second param must be a buffer object");
		return NULL;
	}

	// Phew... finally, all the arguments are converted...
	Py_BEGIN_ALLOW_THREADS
	ok = AcceptEx(
		sListening,
		sAccepting,
		buf,
		dwBufSize - iMinBufferSize,
		wsProtInfo.iMaxSockAddr + 16,
		wsProtInfo.iMaxSockAddr + 16,
		&cBytesRecvd,
		pOverlapped);
	Py_END_ALLOW_THREADS
	if (!ok)
	{
		rc = WSAGetLastError();
		if (rc != ERROR_IO_PENDING)
		{
			PyWin_SetAPIError("AcceptEx", WSAGetLastError());
			goto Error;
		}
	}
	Py_DECREF(pORB);
	rv = PyInt_FromLong(rc);
Cleanup:
	return rv;
Error:
	Py_DECREF(pORB);
	rv = NULL;
	goto Cleanup;
}

static PyObject *
MyMakeIPAddr(SOCKADDR_IN *addr)
{
	long x = ntohl(addr->sin_addr.s_addr);
	char buf[100];
	sprintf(buf, "%d.%d.%d.%d",
		(int) (x>>24) & 0xff, (int) (x>>16) & 0xff,
		(int) (x>> 8) & 0xff, (int) (x>> 0) & 0xff);
	return PyString_FromString(buf);
}

static PyObject *
MyMakeSockaddr(SOCKADDR *addr, INT cbAddr)
{
	if (cbAddr == 0)
	{
		/* No address -- may be recvfrom() from known socket */
		Py_INCREF(Py_None);
		return Py_None;
	}

	switch (addr->sa_family) {
	case AF_INET:
	{
		SOCKADDR_IN *a = (SOCKADDR_IN *) addr;
		PyObject *addrobj = MyMakeIPAddr(a);
		PyObject *ret = NULL;
		if (addrobj) {
			ret = Py_BuildValue("Oi", addrobj, ntohs(a->sin_port));
			Py_DECREF(addrobj);
		}
		return ret;
	}

	/* More cases here... */

	default:
		/* If we don't know the address family, don't raise an
		   exception -- return it as a tuple. */
		return Py_BuildValue("is#",
				     addr->sa_family,
				     addr->sa_data,
				     sizeof(addr->sa_data));

	}
}



// @pyswig (iFamily, <o LocalSockAddr>, <o RemoteSockAddr>)|GetAcceptExSockaddrs|Parses the connection endpoints from the buffer passed into AcceptEx
PyObject *MyGetAcceptExSockaddrs
(
	PyObject *self,
	PyObject *args
)
{
	PyObject *rv = NULL;
	PyObject *obAccepting = NULL;
	PyObject *obBuf = NULL;
	SOCKET sAccepting;
	int iMinBufferSize = (sizeof(SOCKADDR_IN) + 16) * 2;
	WSAPROTOCOL_INFO wsProtInfo;
	UINT cbSize = sizeof(wsProtInfo);
	SOCKADDR *psaddrLocal = NULL;
	SOCKADDR *psaddrRemote = NULL;
	void *buf = NULL;
	PyObject *pORB = NULL;
	INT cbLocal = 0;
	INT cbRemote = 0;
	SOCKADDR_IN *psaddrIN = NULL;
	PyObject *obTemp = NULL;
	int rc;
	DWORD dwBufSize;
	PyBufferProcs *pb = NULL;

	if (!PyArg_ParseTuple(
		args,
		"OO:GetAcceptExSockaddrs",
		&obAccepting, // @pyparm <o PySocket>/int|sAccepting||Socket that was passed into the sAccepting parameter of AcceptEx
		&obBuf)) // @pyparm <o PyOVERLAPPEDReadBuffer>|buffer||Buffer you passed into AcceptEx 
	{
		return NULL;
	}

	if (!PySocket_AsSOCKET(obAccepting, &sAccepting))
	{
		return NULL;
	}

	// Grab the protocol information for the socket
	// So we can compute the correct minimum buffer size.
	Py_BEGIN_ALLOW_THREADS
	rc = getsockopt(
		sAccepting,
		SOL_SOCKET,
		SO_PROTOCOL_INFO,
		(char *)&wsProtInfo,
		(int *)&cbSize);
	Py_END_ALLOW_THREADS
	if (rc == SOCKET_ERROR)
	{
			PyWin_SetAPIError("getsockopt", WSAGetLastError());
			return NULL;
	}
	iMinBufferSize = (wsProtInfo.iMaxSockAddr + 16) * 2;

	if (obBuf->ob_type->tp_as_buffer)
	{
		pORB = obBuf;
		Py_INCREF(pORB);
		pb = pORB->ob_type->tp_as_buffer;
		dwBufSize = (*pb->bf_getreadbuffer)(pORB, 0, &buf);
		if (dwBufSize < (DWORD)iMinBufferSize )
		{
			PyErr_Format(
				PyExc_ValueError,
				"Second param must be at least %ld bytes long",
				iMinBufferSize);
			goto Error;
		}
	}
	else
	{
		PyErr_SetString(PyExc_TypeError, "Second param must be a buffer object");
		return NULL;
	}

	cbRemote = cbLocal = wsProtInfo.iMaxSockAddr + 16;
	Py_BEGIN_ALLOW_THREADS
	GetAcceptExSockaddrs(
		buf,
		dwBufSize - iMinBufferSize,
		cbLocal,
		cbRemote,
		&psaddrLocal,
		&cbLocal,
		&psaddrRemote,
		&cbRemote);
	Py_END_ALLOW_THREADS

	// Now construct the return value.
	rv = PyTuple_New(3);
	if (rv == NULL)
	{
		return NULL;
	}

	//@comm LocalSockAddr and RemoteSockAddr are ("xx.xx.xx.xx", port#) if iFamily == AF_INET
	//@comm otherwise LocalSockAddr and RemoteSockAddr are just binary strings
	//@comm and they should be unpacked with the struct module.

	// Stick in sa_family.
	obTemp = PyInt_FromLong((LONG)psaddrLocal->sa_family);
	if (obTemp == NULL)
	{
		goto Error;
	}
	PyTuple_SET_ITEM(rv, 0, obTemp);
	obTemp = NULL;

	// Construct local address.
	obTemp = MyMakeSockaddr(psaddrLocal, cbLocal);
	if (obTemp == NULL)
	{
		goto Error;
	}
	PyTuple_SET_ITEM(rv, 1, obTemp);
	obTemp = NULL;

	// Construct remote address.
	obTemp = MyMakeSockaddr(psaddrRemote, cbRemote);
	if (obTemp == NULL)
	{
		goto Error;
	}
	PyTuple_SET_ITEM(rv, 2, obTemp);
	obTemp = NULL;
	
Cleanup:
	return rv;
Error:
	Py_DECREF(rv);
	rv = NULL;
	goto Cleanup;
}


%}

%{
PyObject* MyWSAEventSelect
(
	SOCKET *s, 
	PyHANDLE hEvent,
	LONG lNetworkEvents
)
{
	int rc;
	Py_BEGIN_ALLOW_THREADS;
	rc = WSAEventSelect(*s, hEvent, lNetworkEvents);
	Py_END_ALLOW_THREADS;
	if (rc == SOCKET_ERROR)
	{
		PyWin_SetAPIError("WSAEventSelect", WSAGetLastError());
		return NULL;
	}
	Py_INCREF(Py_None);
	return Py_None;
}

%}

// @pyswig |WSAEventSelect|Specifies an event object to be associated with the supplied set of FD_XXXX network events.
%name(WSAEventSelect) PyObject *MyWSAEventSelect
(
	SOCKET *s, // @pyparm <o PySocket>|socket||socket to attach to the event
	PyHANDLE hEvent, // @pyparm <o PyHandle>|hEvent||Event handle for the socket to become attached to.
	LONG lNetworkEvents // @pyparm int|networkEvents||A bitmask of network events that will cause hEvent to be signaled. e.g. (FD_CLOSE \| FD_READ)
);
%{

PyObject* MyWSAAsyncSelect
(
	SOCKET *s, 
	LONG hwnd,
	LONG wMsg,
	LONG lNetworkEvents
)
{
	int rc;
	Py_BEGIN_ALLOW_THREADS;
	rc = WSAAsyncSelect(*s, (HWND)hwnd, wMsg, lNetworkEvents);
	Py_END_ALLOW_THREADS;
	if (rc == SOCKET_ERROR)
	{
		PyWin_SetAPIError("WSAAsyncSelect", WSAGetLastError());
		return NULL;
	}
	Py_INCREF(Py_None);
	return Py_None;
}

%}

// @pyswig |WSAAsyncSelect|Request windows message notification for the supplied set of FD_XXXX network events.
%name(WSAAsyncSelect) PyObject *MyWSAAsyncSelect
(
	SOCKET *s, // @pyparm <o PySocket>|socket||socket to attach to the event
	LONG hwnd, // @pyparm <o hwnd>|hwnd||Window handle for the socket to become attached to.
	LONG wMsg, // @pyparm <o int>|int||Window message that will be posted.
	LONG lNetworkEvents // @pyparm int|networkEvents||A bitmask of network events that will cause wMsg to be posted. e.g. (FD_CLOSE \| FD_READ)
);

%native(WSASend) MyWSASend;
%native(WSARecv) MyWSARecv;

%{
// @pyswig (rc, cBytesSent)|WSASend|Winsock send() equivalent function for Overlapped I/O.
PyObject *MyWSASend
(
	PyObject *self,
	PyObject *args
)
{
	SOCKET s;
	PyObject *obSocket = NULL;
	WSABUF wsBuf;
	DWORD cbSent = 0;
	OVERLAPPED *pOverlapped = NULL;
	int rc = 0;
	PyObject *rv = NULL;
	PyObject *obTemp = NULL;
	PyObject *obBuf = NULL;
	PyObject *obOverlapped = NULL;
	DWORD dwFlags = 0;
	PyBufferProcs *pb = NULL;

	if (!PyArg_ParseTuple(
		args,
		"OOO|i:WSASend",
		&obSocket, // @pyparm <o PySocket>/int|s||Socket to send data on.
		&obBuf, // @pyparm string/<o buffer>|buffer||Buffer to send data from.
		&obOverlapped, // @pyparm <o PyOVERLAPPED>|ol||An overlapped structure
		&dwFlags)) // @pyparm int|dwFlags||Optional send flags.
	{
		return NULL;
	}

	if (!PySocket_AsSOCKET(obSocket, &s))
	{
		return NULL;
	}

	if (!PyWinObject_AsOVERLAPPED(obOverlapped, &pOverlapped))
	{
		return NULL;
	}

	if (PyString_Check(obBuf))
	{
		wsBuf.buf = PyString_AS_STRING(obBuf);
		wsBuf.len = PyString_GET_SIZE(obBuf);
	}
	else if (obBuf->ob_type->tp_as_buffer)
	{
		Py_INCREF(obBuf);
		pb = obBuf->ob_type->tp_as_buffer;
		wsBuf.len = (*pb->bf_getreadbuffer)(obBuf, 0, (void **)&wsBuf.buf);
	}
	else
	{
		PyErr_SetString(PyExc_TypeError, "Second param must be a buffer object or a string.");
		return NULL;
	}

	Py_BEGIN_ALLOW_THREADS;
	rc = WSASend(
		s,
		&wsBuf,
		1,
		&cbSent,
		dwFlags,
		pOverlapped,
		NULL);
	Py_END_ALLOW_THREADS;

	if (rc == SOCKET_ERROR)
	{
		rc = WSAGetLastError();
		if (rc != ERROR_IO_PENDING)
		{
			PyWin_SetAPIError("WSASend", rc);
			goto Error;
		}
	}

	rv = PyTuple_New(2);
	if (rv == NULL)
	{
		goto Error;
	}

	obTemp = PyInt_FromLong(rc);
	if (obTemp == NULL)
	{
		goto Error;
	}
	PyTuple_SET_ITEM(rv, 0, obTemp);
	obTemp = NULL;

	obTemp = PyInt_FromLong(cbSent);
	if (obTemp == NULL)
	{
		goto Error;
	}
	PyTuple_SET_ITEM(rv, 1, obTemp);
	obTemp = NULL;

Cleanup:
	return rv;
Error:
	Py_XDECREF(obBuf);
	Py_XDECREF(rv);
	rv = NULL;
	goto Cleanup;
}

// @pyswig (rc, cBytesRecvd)|WSARecv|Winsock recv() equivalent function for Overlapped I/O.
PyObject *MyWSARecv
(
	PyObject *self,
	PyObject *args
)
{
	SOCKET s;
	PyObject *obSocket = NULL;
	WSABUF wsBuf;
	DWORD cbRecvd = 0;
	OVERLAPPED *pOverlapped = NULL;
	int rc = 0;
	PyObject *rv = NULL;
	PyObject *obTemp = NULL;
	PyObject *obBuf = NULL;
	PyObject *obOverlapped = NULL;
	DWORD dwFlags = 0;
	PyBufferProcs *pb = NULL;

	if (!PyArg_ParseTuple(
		args,
		"OOO|i:WSARecv",
		&obSocket, // @pyparm <o PySocket>/int|s||Socket to send data on.
		&obBuf, // @pyparm <o buffer>|buffer||Buffer to send data from.
		&obOverlapped, // @pyparm <o PyOVERLAPPED>|ol||An overlapped structure
		&dwFlags)) // @pyparm int|dwFlags||Optional reception flags.
	{
		return NULL;
	}

	if (!PySocket_AsSOCKET(obSocket, &s))
	{
		return NULL;
	}

	if (!PyWinObject_AsOVERLAPPED(obOverlapped, &pOverlapped))
	{
		return NULL;
	}

	if (obBuf->ob_type->tp_as_buffer)
	{
		Py_INCREF(obBuf);
		pb = obBuf->ob_type->tp_as_buffer;
		wsBuf.len = (*pb->bf_getreadbuffer)(obBuf, 0, (void **)&wsBuf.buf);
	}
	else
	{
		PyErr_SetString(PyExc_TypeError, "Second param must be a PyOVERLAPPEDReadBuffer object");
		return NULL;
	}

	Py_BEGIN_ALLOW_THREADS;
	rc = WSARecv(
		s,
		&wsBuf,
		1,
		&cbRecvd,
		&dwFlags,
		pOverlapped,
		NULL);
	Py_END_ALLOW_THREADS;

	if (rc == SOCKET_ERROR)
	{
		rc = WSAGetLastError();
		if (rc != ERROR_IO_PENDING)
		{
			PyWin_SetAPIError("WSARecv", rc);
			goto Error;
		}
	}

	rv = PyTuple_New(2);
	if (rv == NULL)
	{
		goto Error;
	}

	obTemp = PyInt_FromLong(rc);
	if (obTemp == NULL)
	{
		goto Error;
	}
	PyTuple_SET_ITEM(rv, 0, obTemp);
	obTemp = NULL;

	obTemp = PyInt_FromLong(cbRecvd);
	if (obTemp == NULL)
	{
		goto Error;
	}
	PyTuple_SET_ITEM(rv, 1, obTemp);
	obTemp = NULL;

Cleanup:
	return rv;
Error:
	Py_DECREF(obBuf);
	Py_XDECREF(rv);
	rv = NULL;
	goto Cleanup;
}


%}

#define SO_UPDATE_ACCEPT_CONTEXT SO_UPDATE_ACCEPT_CONTEXT
#define SO_CONNECT_TIME SO_CONNECT_TIME

#define WSAEWOULDBLOCK WSAEWOULDBLOCK
#define WSAENETDOWN WSAENETDOWN
#define WSAENOTCONN WSAENOTCONN
#define WSAEINTR WSAEINTR
#define WSAEINPROGRESS WSAEINPROGRESS
#define WSAENETRESET WSAENETRESET
#define WSAENOTSOCK WSAENOTSOCK
#define WSAEFAULT WSAEFAULT
#define WSAEOPNOTSUPP WSAEOPNOTSUPP
#define WSAESHUTDOWN WSAESHUTDOWN
#define WSAEMSGSIZE WSAEMSGSIZE
#define WSAEINVAL WSAEINVAL
#define WSAECONNABORTED WSAECONNABORTED
#define WSAECONNRESET WSAECONNRESET
#define WSAEDISCON WSAEDISCON
#define WSA_IO_PENDING WSA_IO_PENDING
#define WSA_OPERATION_ABORTED WSA_OPERATION_ABORTED
#define FD_READ FD_READ
#define FD_WRITE FD_WRITE
#define FD_OOB FD_OOB
#define FD_ACCEPT FD_ACCEPT
#define FD_CONNECT FD_CONNECT
#define FD_CLOSE FD_CLOSE
#define FD_QOS FD_QOS
#define FD_GROUP_QOS FD_GROUP_QOS
#define FD_ROUTING_INTERFACE_CHANGE FD_ROUTING_INTERFACE_CHANGE
#define FD_ADDRESS_LIST_CHANGE FD_ADDRESS_LIST_CHANGE

#endif // MS_WINCE

// The communications related functions.
// The COMM port enhancements were added by Mark Hammond, and are
// (c) 2000-2001, ActiveState Tools Corp.

%{
// The comms port helpers.
extern PyObject *PyWinObject_FromCOMSTAT(const COMSTAT *pCOMSTAT);
extern BOOL PyWinObject_AsCOMSTAT(PyObject *ob, COMSTAT **ppCOMSTAT, BOOL bNoneOK = TRUE);
extern BOOL PyWinObject_AsDCB(PyObject *ob, DCB **ppDCB, BOOL bNoneOK = TRUE);
extern PyObject *PyWinObject_FromDCB(const DCB *pDCB);
extern PyObject *PyWinMethod_NewDCB(PyObject *self, PyObject *args);
extern PyObject *PyWinObject_FromCOMMTIMEOUTS( COMMTIMEOUTS *p);
extern BOOL PyWinObject_AsCOMMTIMEOUTS( PyObject *ob, COMMTIMEOUTS *p);

%}

%native (DCB) PyWinMethod_NewDCB;

%typemap(python,in) DCB *
{
	if (!PyWinObject_AsDCB($source, &$target, TRUE))
		return NULL;
}
%typemap(python,argout) DCB *OUTPUT {
    PyObject *o;
    o = PyWinObject_FromDCB($source);
    if (!$target) {
      $target = o;
    } else if ($target == Py_None) {
      Py_DECREF(Py_None);
      $target = o;
    } else {
      if (!PyList_Check($target)) {
	PyObject *o2 = $target;
	$target = PyList_New(0);
	PyList_Append($target,o2);
	Py_XDECREF(o2);
      }
      PyList_Append($target,o);
      Py_XDECREF(o);
    }
}
%typemap(python,ignore) DCB *OUTPUT(DCB temp)
{
  $target = &temp;
  $target->DCBlength = sizeof( DCB ) ;
}

%typemap(python,in) COMSTAT *
{
	if (!PyWinObject_AsCOMSTAT($source, &$target, TRUE))
		return NULL;
}
%typemap(python,argout) COMSTAT *OUTPUT {
    PyObject *o;
    o = PyWinObject_FromCOMSTAT(*$source);
    if (!$target) {
      $target = o;
    } else if ($target == Py_None) {
      Py_DECREF(Py_None);
      $target = o;
    } else {
      if (!PyList_Check($target)) {
	PyObject *o2 = $target;
	$target = PyList_New(0);
	PyList_Append($target,o2);
	Py_XDECREF(o2);
      }
      PyList_Append($target,o);
      Py_XDECREF(o);
    }
}
%typemap(python,ignore) COMSTAT *OUTPUT(COMSTAT temp)
{
  $target = &temp;
}


%typemap(python,in) COMMTIMEOUTS *(COMMTIMEOUTS temp)
{
	$target = &temp;
	if (!PyWinObject_AsCOMMTIMEOUTS($source, $target))
		return NULL;
}

%typemap(python,argout) COMMTIMEOUTS *OUTPUT {
    PyObject *o;
    o = PyWinObject_FromCOMMTIMEOUTS($source);
    if (!$target) {
      $target = o;
    } else if ($target == Py_None) {
      Py_DECREF(Py_None);
      $target = o;
    } else {
      if (!PyList_Check($target)) {
	PyObject *o2 = $target;
	$target = PyList_New(0);
	PyList_Append($target,o2);
	Py_XDECREF(o2);
      }
      PyList_Append($target,o);
      Py_XDECREF(o);
    }
}
%typemap(python,ignore) COMMTIMEOUTS *OUTPUT(COMMTIMEOUTS temp)
{
  $target = &temp;
}


// @pyswig <o PyDCB>|BuildCommDCB|Fills the specified DCB structure with values specified in a device-control string. The device-control string uses the syntax of the mode command
BOOLAPI BuildCommDCB(
  TCHAR *lpDef,  // @pyparm string|def||device-control string
  DCB *OUTOUT     // @pyparm <o PyDCB>|dcb||The device-control block
);

%{
// @pyswig int, <o PyCOMSTAT>|ClearCommError|retrieves information about a communications error and reports the current status of a communications device.
static PyObject *PyClearCommError(PyObject *self, PyObject *args)
{
	PyObject *obHandle;
	// @pyparm handle|<o PyHANDLE>||A handle to the device.
	if (!PyArg_ParseTuple(args, "O", &obHandle))
		return NULL;
	HANDLE handle;
	if (!PyWinObject_AsHANDLE(obHandle, &handle, FALSE))
		return NULL;
	BOOL rc;
	DWORD int_ret;
	COMSTAT stat;
	Py_BEGIN_ALLOW_THREADS;
	rc = ClearCommError(handle, &int_ret, &stat);
	Py_END_ALLOW_THREADS;
	if (!rc)
		return PyWin_SetAPIError("ClearCommError");
	PyObject *obStat = PyWinObject_FromCOMSTAT(&stat);
	PyObject *ret = Py_BuildValue("iO", int_ret, obStat);
	Py_XDECREF(obStat);
	return ret;
}

%}
%native (ClearCommError) PyClearCommError;

// @pyswig |EscapeCommFunction|directs a specified communications device to perform an extended function. 
BOOLAPI EscapeCommFunction(
	PyHANDLE handle, // @pyparm <o PyHANDLE>|handle||The handle to the communications device.
	int func // int|func||Specifies the code of the extended function to perform. This parameter can be one of the following values. 
	// @flagh Value|Meaning 
	// @flag CLRDTR|Clears the DTR (data-terminal-ready) signal. 
	// @flag CLRRTS|Clears the RTS (request-to-send) signal. 
	// @flag SETDTR|Sends the DTR (data-terminal-ready) signal. 
	// @flag SETRTS|Sends the RTS (request-to-send) signal. 
	// @flag SETXOFF|Causes transmission to act as if an XOFF character has been received. 
	// @flag SETXON|Causes transmission to act as if an XON character has been received. 
	// @flag SETBREAK|Suspends character transmission and places the transmission line in a break state until the ClearCommBreak function is called (or EscapeCommFunction is called with the CLRBREAK extended function code). The SETBREAK extended function code is identical to the SetCommBreak function. Note that this extended function does not flush data that has not been transmitted. 
	// @flag CLRBREAK|Restores character transmission and places the transmission line in a nonbreak state. The CLRBREAK extended function code is identical to the ClearCommBreak function. 
);

// @pyswig <o PyDCB>|GetCommState|Returns a device-control block (a DCB structure) with the current control settings for a specified communications device.
BOOLAPI GetCommState(
	PyHANDLE handle, // @pyparm <o PyHANDLE>|handle||The handle to the communications device.
	DCB *OUTPUT
);
// @pyswig |SetCommState|Configures a communications device according to the specifications in a device-control block.
// The function reinitializes all hardware and control settings, but it does not empty output or input queues.
BOOLAPI SetCommState(
	PyHANDLE handle, // @pyparm <o PyHANDLE>|handle||The handle to the communications device.
	DCB *dcb // @pyparm <o PyDCB>|dcb||The control settings.
);

// @pyswig |ClearCommBreak|Restores character transmission for a specified communications device and places the transmission line in a nonbreak state
BOOLAPI ClearCommBreak(
	PyHANDLE handle // @pyparm <o PyHANDLE>|handle||The handle to the communications device.
);

// @pyswig int|GetCommMask|Retrieves the value of the event mask for a specified communications device.
BOOLAPI GetCommMask(
	PyHANDLE handle, // @pyparm <o PyHANDLE>|handle||The handle to the communications device.
	unsigned long *OUTPUT
);

// @pyswig int|SetCommMask|Sets the value of the event mask for a specified communications device.
BOOLAPI SetCommMask(
	PyHANDLE handle, // @pyparm <o PyHANDLE>|handle||The handle to the communications device.
	unsigned long val // @pyparm int|val||The new mask value.
);

// @pyswig int|GetCommModemStatus|Retrieves modem control-register values. 
BOOLAPI GetCommModemStatus(
	PyHANDLE handle, // @pyparm <o PyHANDLE>|handle||The handle to the communications device.
	unsigned long *OUTPUT
);

// @pyswig <o PyCOMMTIMEOUTS>|GetCommTimeouts|Retrieves the time-out parameters for all read and write operations on a specified communications device. 
BOOLAPI GetCommTimeouts(
	PyHANDLE handle, // @pyparm <o PyHANDLE>|handle||The handle to the communications device.
	COMMTIMEOUTS *OUTPUT
);

// @pyswig int|SetCommTimeouts|Sets the time-out parameters for all read and write operations on a specified communications device. 
BOOLAPI SetCommTimeouts(
	PyHANDLE handle, // @pyparm <o PyHANDLE>|handle||The handle to the communications device.
	COMMTIMEOUTS *timeouts // @pyparm <o PyCOMMTIMEOUTS>|val||The new time-out parameters.
);

// @pyswig |PurgeComm|Discards all characters from the output or input buffer of a specified communications resource. It can also terminate pending read or write operations on the resource. 
BOOLAPI PurgeComm(
	PyHANDLE handle, // @pyparm <o PyHANDLE>|handle||The handle to the communications device.
	unsigned long val // @pyparm int|action||The action to perform.  This parameter can be one or more of the following values.
	// @flagh Value|Meaning 
	// @flag PURGE_TXABORT|Terminates all outstanding overlapped write operations and returns immediately, even if the write operations have not been completed. 
	// @flag PURGE_RXABORT|Terminates all outstanding overlapped read operations and returns immediately, even if the read operations have not been completed. 
	// @flag PURGE_TXCLEAR|Clears the output buffer (if the device driver has one). 
	// @flag PURGE_RXCLEAR|Clears the input buffer (if the device driver has one). 
);

// @pyswig |SetCommBreak|Suspends character transmission for a specified communications device and places the transmission line in a break state until the <om win32file.ClearCommBreak> function is called. 
BOOLAPI SetCommBreak(
	PyHANDLE handle // @pyparm <o PyHANDLE>|handle||The handle to the communications device.
);

// @pyswig |SetupComm|Initializes the communications parameters for a specified communications device. 
BOOLAPI SetupComm(
	PyHANDLE handle, // @pyparm <o PyHANDLE>|handle||The handle to the communications device.
	unsigned long dwInQueue, // @pyparm int|dwInQueue||Specifies the recommended size, in bytes, of the device's internal input buffer.
	unsigned long dwOutQueue // @pyparm int|dwOutQueue||Specifies the recommended size, in bytes, of the device's internal output buffer.
);

// @pyswig |TransmitCommChar|Transmits a specified character ahead of any pending data in the output buffer of the specified communications device.
BOOLAPI TransmitCommChar(
	PyHANDLE handle, // @pyparm <o PyHANDLE>|handle||The handle to the communications device.
	char ch // @pyparm char|cChar||The character to transmit.
// @comm The TransmitCommChar function is useful for sending an interrupt character (such as a CTRL+C) to a host system. 
// <nl>If the device is not transmitting, TransmitCommChar cannot be called repeatedly. Once TransmitCommChar places a character in the output buffer, the character must be transmitted before the function can be called again. If the previous character has not yet been sent, TransmitCommChar returns an error.
);

%{
// @pyswig |WaitCommEvent|Waits for an event to occur for a specified communications device. The set of events that are monitored by this function is contained in the event mask associated with the device handle.
static PyObject *MyWaitCommEvent(PyObject *self, PyObject *args)
{
	PyObject *obHandle, *obOverlapped = Py_None;
	if (!PyArg_ParseTuple(args, "O|O", 
			&obHandle, // @pyparm <o PyHANDLE>|handle||The handle to the communications device.
			&obOverlapped))// @pyparm <o PyOVERLAPPED>|overlapped||This structure is required if hFile was opened with FILE_FLAG_OVERLAPPED. 
			// <nl>If hFile was opened with FILE_FLAG_OVERLAPPED, the lpOverlapped parameter must not be NULL. It must point to a valid OVERLAPPED structure. If hFile was opened with FILE_FLAG_OVERLAPPED and lpOverlapped is NULL, the function can incorrectly report that the operation is complete. 
			// <nl>If hFile was opened with FILE_FLAG_OVERLAPPED and lpOverlapped is not NULL, WaitCommEvent is performed as an overlapped operation. In this case, the OVERLAPPED structure must contain a handle to a manual-reset event object (created by using the CreateEvent function). 
			// <nl>If hFile was not opened with FILE_FLAG_OVERLAPPED, WaitCommEvent does not return until one of the specified events or an error occurs. 
		return NULL;
	HANDLE handle;
	if (!PyWinObject_AsHANDLE(obHandle, &handle, FALSE))
		return NULL;
	PyOVERLAPPED *pyoverlapped;
	if (!PyWinObject_AsPyOVERLAPPED(obOverlapped, &pyoverlapped, TRUE))
		return NULL;
	DWORD mask, *pmask;
	if (pyoverlapped)
		pmask = &pyoverlapped->m_overlapped.dwValue;
	else
		pmask = &mask;

	BOOL ok;
	Py_BEGIN_ALLOW_THREADS
	ok = WaitCommEvent(handle, pmask, 
	                   pyoverlapped ? pyoverlapped->GetOverlapped() : NULL);
	Py_END_ALLOW_THREADS
	DWORD rc = ok ? 0 : GetLastError();
	if (rc!=0 && rc != ERROR_IO_PENDING)
		return PyWin_SetAPIError("WaitCommEvent", rc);
	return Py_BuildValue("ll", rc, *pmask);
	// @rdesc The result is a tuple of (rc, mask_val), where rc is zero for success, or
	// the result of calling GetLastError() otherwise.  The mask_val is the new mask value
	// once the function has returned, but if an Overlapped object is passed, this value
	// will generally be meaningless.  See the comments for more details.
	// @comm If an overlapped structure is passed, then the <om PyOVERLAPPED.dword> 
	// address is passed to the Win32 API as the mask.  This means that once the
	// overlapped operation has completed, this dword attribute can be used to
	// determine the type of event that occurred.
}
%}
%native (WaitCommEvent) MyWaitCommEvent;

// Some Win2k specific volume mounting functions, thanks to Roger Upole
%{
#define CHECK_PFN(fname) if (pfn##fname==NULL) return PyErr_Format(PyExc_NotImplementedError,"%s is not available on this platform", #fname);
static BOOL (WINAPI *pfnGetVolumeNameForVolumeMountPointW)(LPCWSTR, LPCWSTR, DWORD) = NULL;
static BOOL (WINAPI *pfnSetVolumeMountPointW)(LPCWSTR, LPCWSTR) = NULL;
static BOOL (WINAPI *pfnDeleteVolumeMountPointW)(LPCWSTR) = NULL;
static BOOL (WINAPI *pfnCreateHardLinkW)(LPCWSTR, LPCWSTR, LPSECURITY_ATTRIBUTES ) = NULL;
static BOOL (WINAPI *pfnEncryptFile)(WCHAR *)=NULL;
static BOOL (WINAPI *pfnDecryptFile)(WCHAR *, DWORD)=NULL;
static BOOL (WINAPI *pfnEncryptionDisable)(WCHAR *, BOOL)=NULL;
static BOOL (WINAPI *pfnFileEncryptionStatus)(WCHAR *, LPDWORD)=NULL;
static DWORD (WINAPI *pfnQueryUsersOnEncryptedFile)(WCHAR *, PENCRYPTION_CERTIFICATE_HASH_LIST *)=NULL;
static BOOL (WINAPI *pfnFreeEncryptionCertificateHashList)(PENCRYPTION_CERTIFICATE_HASH_LIST)=NULL;
static DWORD (WINAPI *pfnQueryRecoveryAgentsOnEncryptedFile)(WCHAR *, PENCRYPTION_CERTIFICATE_HASH_LIST *)=NULL;
static DWORD (WINAPI *pfnRemoveUsersFromEncryptedFile)(WCHAR *, PENCRYPTION_CERTIFICATE_HASH_LIST)=NULL;
static DWORD (WINAPI *pfnAddUsersToEncryptedFile)(WCHAR *, PENCRYPTION_CERTIFICATE_LIST)=NULL;
static BOOL (WINAPI *pfnGetVolumePathNameW)(WCHAR *, WCHAR *, DWORD)=NULL;


typedef BOOL (WINAPI *BackupReadfunc)(HANDLE, LPBYTE, DWORD, LPDWORD, BOOL, BOOL, LPVOID*);
static BackupReadfunc pfnBackupRead=NULL;
typedef BOOL (WINAPI *BackupSeekfunc)(HANDLE, DWORD, DWORD, LPDWORD, LPDWORD, LPVOID*);
static BackupSeekfunc pfnBackupSeek=NULL;
typedef BOOL (WINAPI *BackupWritefunc)(HANDLE, LPBYTE, DWORD, LPDWORD, BOOL, BOOL, LPVOID*);
static BackupWritefunc pfnBackupWrite=NULL;

typedef BOOL (WINAPI *SetFileShortNamefunc)(HANDLE, LPCWSTR);
static SetFileShortNamefunc pfnSetFileShortName=NULL;
typedef BOOL (WINAPI *CopyFileExfunc)(LPWSTR,LPWSTR,LPPROGRESS_ROUTINE,LPVOID,LPBOOL,DWORD);
static CopyFileExfunc pfnCopyFileEx=NULL;
typedef BOOL (WINAPI *MoveFileWithProgressfunc)(LPWSTR,LPWSTR,LPPROGRESS_ROUTINE,LPVOID,DWORD);
static MoveFileWithProgressfunc pfnMoveFileWithProgress=NULL;
typedef BOOL (WINAPI *ReplaceFilefunc)(LPCWSTR,LPCWSTR,LPCWSTR,DWORD,LPVOID,LPVOID);
static ReplaceFilefunc pfnReplaceFile=NULL;

typedef DWORD (WINAPI *OpenEncryptedFileRawfunc)(LPCWSTR,ULONG,PVOID *);
static OpenEncryptedFileRawfunc pfnOpenEncryptedFileRaw=NULL;
typedef DWORD (WINAPI *ReadEncryptedFileRawfunc)(PFE_EXPORT_FUNC,PVOID,PVOID);
static ReadEncryptedFileRawfunc pfnReadEncryptedFileRaw=NULL;
typedef DWORD (WINAPI *WriteEncryptedFileRawfunc)(PFE_IMPORT_FUNC,PVOID,PVOID);
static WriteEncryptedFileRawfunc pfnWriteEncryptedFileRaw=NULL;
typedef void (WINAPI *CloseEncryptedFileRawfunc)(PVOID);
static CloseEncryptedFileRawfunc pfnCloseEncryptedFileRaw=NULL;


// @pyswig <o PyUnicode>|SetVolumeMountPoint|Mounts the specified volume at the specified volume mount point.
static PyObject*
py_SetVolumeMountPoint(PyObject *self, PyObject *args)
{
    // @ex Usage|SetVolumeMountPoint('h:\tmp\','c:\')
    // @pyparm string|mountPoint||The mount point - must be an existing empty directory on an NTFS volume
    // @pyparm string|volumeName||The volume to mount there 
    // @comm Note that both parameters must have trailing backslashes.
    // @rdesc The result is the GUID of the volume mounted, as a string.
    // @comm This method exists only on Windows 2000.If there
    // is an attempt to use it on these platforms, an error with E_NOTIMPL will be raised.
    PyObject *ret=NULL;
    PyObject *volume_obj = NULL, *mount_point_obj = NULL;
    // LPWSTR volume = NULL, mount_point = NULL;

    WCHAR *volume = NULL;
    WCHAR *mount_point = NULL;
    WCHAR volume_name[50];
	if ((pfnSetVolumeMountPointW==NULL)||(pfnGetVolumeNameForVolumeMountPointW==NULL))
		return PyErr_Format(PyExc_NotImplementedError,"SetVolumeMountPoint not supported by this version of Windows");

    if (!PyArg_ParseTuple(args,"OO", &mount_point_obj, &volume_obj))
        return NULL;

    if (!PyWinObject_AsWCHAR(mount_point_obj, &mount_point, false)){
        PyErr_SetString(PyExc_TypeError,"Mount point must be string or unicode");
        goto cleanup;
    }

    if (!PyWinObject_AsWCHAR(volume_obj, &volume, false)){
        PyErr_SetString(PyExc_TypeError,"Volume name must be string or unicode");
        goto cleanup;
    }

    assert(pfnGetVolumeNameForVolumeMountPointW);
    if (!(*pfnGetVolumeNameForVolumeMountPointW)(volume,volume_name,sizeof(volume_name)/sizeof(volume_name[0]))){
        PyWin_SetAPIError("GetVolumeNameForVolumeMountPoint");
        goto cleanup;
    }
    assert(pfnSetVolumeMountPointW);
    if (!(*pfnSetVolumeMountPointW)(mount_point, volume_name)){
        PyWin_SetAPIError("SetVolumeMountPoint");
        goto cleanup;
    }
    ret=PyWinObject_FromWCHAR(volume_name);
cleanup:
    PyWinObject_FreeWCHAR(volume);
    PyWinObject_FreeWCHAR(mount_point);

    return ret;
}

// @pyswig |DeleteVolumeMountPoint|Unmounts the volume from the specified volume mount point.
static PyObject*
py_DeleteVolumeMountPoint(PyObject *self, PyObject *args)
{
    // @ex Usage|DeleteVolumeMountPoint('h:\tmp\')
    // @pyparm string|mountPoint||The mount point to delete - must have a trailing backslash.
    // @comm Throws an error if it is not a valid mount point, returns None on success.
    // <nl>Use carefully - will remove drive letter assignment if no directory specified
    // @comm This method exists only on Windows 2000.If there
    // is an attempt to use it on these platforms, an error with E_NOTIMPL will be raised.

    PyObject *ret=NULL;
    PyObject *mount_point_obj = NULL;
    WCHAR *mount_point = NULL;

    if (pfnDeleteVolumeMountPointW==NULL)
        return PyErr_Format(PyExc_NotImplementedError,"DeleteVolumeMountPoint not supported by this version of Windows");

    if (!PyArg_ParseTuple(args,"O", &mount_point_obj))
        return NULL;

    if (!PyWinObject_AsWCHAR(mount_point_obj, &mount_point, false)){
        PyErr_SetString(PyExc_TypeError,"Mount point must be string or unicode");
        goto cleanup;
    }

    if (!(*pfnDeleteVolumeMountPointW)(mount_point)){
        PyWin_SetAPIError("DeleteVolumeMountPoint");
    }
    else
        ret=Py_None;
    PyWinObject_FreeWCHAR(mount_point);

    cleanup:
    Py_XINCREF(ret);
    return ret;
}

// @pyswig |CreateHardLink|Establishes an NTFS hard link between an existing file and a new file.
static PyObject*
py_CreateHardLink(PyObject *self, PyObject *args)
{
    // @comm  An NTFS hard link is similar to a POSIX hard link.
    // <nl>This function creates a second directory entry for an existing file, can be different name in
    // same directory or any name in a different directory.
    // Both file paths must be on the same NTFS volume.<nl>To remove the link, simply delete 
    // it and the original file will still remain.
    // @ex Usage|CreateHardLink('h:\dir\newfilename.txt','h:\otherdir\existingfile.txt')
    // @pyparm string|fileName||The name of the new directory entry to be created.
    // @pyparm string|existingName||The name of the existing file to which the new link will point.
    // @pyparm <o PySECURITY_ATTRIBUTES>|security||a SECURITY_ATTRIBUTES structure that specifies a security descriptor for the new file.
    // If this parameter is None, it leaves the file's existing security descriptor unmodified. 
    // If this parameter is not None, it modifies the file's security descriptor. 
    // @comm This method exists only on Windows 2000.If there
    // is an attempt to use it on these platforms, an error with E_NOTIMPL will be raised.

    PyObject *ret=NULL;
    PyObject *new_file_obj;
    PyObject *existing_file_obj;
    PyObject *sa_obj = Py_None;
    WCHAR *new_file = NULL;
    WCHAR *existing_file = NULL;
    SECURITY_ATTRIBUTES *sa;

    if (pfnCreateHardLinkW==NULL)
        return PyErr_Format(PyExc_NotImplementedError,"CreateHardLink not supported by this version of Windows");
    if (!PyArg_ParseTuple(args,"OO|O", &new_file_obj, &existing_file_obj, &sa_obj))
        return NULL;

    if (!PyWinObject_AsWCHAR(new_file_obj, &new_file, false)){
        PyErr_SetString(PyExc_TypeError,"New file name must be string or unicode");
        goto cleanup;
    }

    if (!PyWinObject_AsWCHAR(existing_file_obj, &existing_file, false)){
        PyErr_SetString(PyExc_TypeError,"Existing file name must be string or unicode");
        goto cleanup;
    }

    if (!PyWinObject_AsSECURITY_ATTRIBUTES(sa_obj, &sa, true)){
        PyErr_SetString(PyExc_TypeError,"3rd param must be a SECURITY_ATTRIBUTES, or None");
        goto cleanup;
    }

    if (!((*pfnCreateHardLinkW)(new_file, existing_file, sa))){
        PyWin_SetAPIError("CreateHardLink");
        goto cleanup;
    }
    ret=Py_None;
    Py_INCREF(Py_None);
cleanup:
    PyWinObject_FreeWCHAR(new_file);
    PyWinObject_FreeWCHAR(existing_file);
    return ret;
}

// @pyswig <o PyUnicode>|GetVolumeNameForVolumeMountPoint|Returns unique volume name (Win2k or later)
static PyObject*
py_GetVolumeNameForVolumeMountPoint(PyObject *self, PyObject *args)
{
    // @pyparm string|mountPoint||Volume mount point or root drive - trailing backslash required
    PyObject *ret=NULL;
    PyObject *obvolume_name = NULL, *obmount_point = NULL;

    WCHAR *mount_point = NULL;
    WCHAR volume_name[50];
    if (pfnGetVolumeNameForVolumeMountPointW==NULL)
        return PyErr_Format(PyExc_NotImplementedError,"GetVolumeNameForVolumeMountPoint not supported by this version of Windows");

    if (!PyArg_ParseTuple(args,"O:GetVolumeNameForVolumeMountPoint", &obmount_point))
        return NULL;

    if (!PyWinObject_AsWCHAR(obmount_point, &mount_point, false)){
        PyErr_SetString(PyExc_TypeError,"Mount point must be string or unicode");
        goto cleanup;
    }

    assert(pfnGetVolumeNameForVolumeMountPointW);
    if (!(*pfnGetVolumeNameForVolumeMountPointW)(mount_point, volume_name, sizeof(volume_name)/sizeof(volume_name[0])))
        PyWin_SetAPIError("GetVolumeNameForVolumeMountPoint");
	else
        ret=PyWinObject_FromWCHAR(volume_name);
cleanup:
	PyWinObject_FreeWCHAR(mount_point);
	return ret;
}

// @pyswig <o PyUnicode>|GetVolumePathName|Returns volume mount point for a path
// @comm Api gives no indication of how much memory is needed, so function assumes returned path
//       will not be longer that length of input path + 1.
//       Use GetFullPathName first for relative paths, or GetLongPathName for 8.3 paths.
//       Optional second parm can also be used to override the buffer size for returned path
static PyObject*
py_GetVolumePathName(PyObject *self, PyObject *args)
{
	// @pyparm string/unicode|FileName||File/dir for which to return volume mount point
	// @pyparm int|bufsize|0|Optional parm to allocate extra space for returned string
	PyObject *ret=NULL;
	PyObject *obpath = NULL;
	WCHAR *path=NULL, *mount_point=NULL;
	DWORD pathlen, bufsize=0;
	if (pfnGetVolumePathNameW==NULL)
		return PyErr_Format(PyExc_NotImplementedError,"GetVolumePathName not supported by this version of Windows");
	if (!PyArg_ParseTuple(args,"O|l:GetVolumePathName", &obpath, &bufsize))
		return NULL;
	if (!PyWinObject_AsWCHAR(obpath, &path, FALSE, &pathlen))
		return NULL;

	// yet another function that doesn't tell us how much memory it needs ...
	if (bufsize>0)
		bufsize+=1;
	else
		bufsize=pathlen+2;  // enough to accomodate trailing null, and possibly extra backslash
	mount_point=(WCHAR *)malloc(bufsize*sizeof(WCHAR));
	if (mount_point==NULL)
		PyErr_SetString(PyExc_MemoryError,"GetVolumePathName: Unable to allocate return buffer");
	else
		if (!(*pfnGetVolumePathNameW)(path, mount_point, bufsize))
			PyWin_SetAPIError("GetVolumePathName");
		else
			ret=PyWinObject_FromWCHAR(mount_point);
	if (path != NULL)
		PyWinObject_FreeWCHAR(path);
	if (mount_point!=NULL)
		free(mount_point);
	return ret;
}

// @pyswig |EncryptFile|Encrypts specified file (requires Win2k or higher and NTFS)
static PyObject*
py_EncryptFile(PyObject *self, PyObject *args)
{
    // @pyparm string/unicode|filename||File to encrypt

    PyObject *ret=NULL, *obfname=NULL;
    WCHAR *fname = NULL;
	if (pfnEncryptFile==NULL)
		return PyErr_Format(PyExc_NotImplementedError,"EncryptFile not supported by this version of Windows");
    if (!PyArg_ParseTuple(args,"O", &obfname))
        return NULL;
    if (!PyWinObject_AsWCHAR(obfname, &fname, FALSE))
        return NULL;
	if (!(*pfnEncryptFile)(fname))
        PyWin_SetAPIError("EncryptFile");
    else
        ret=Py_None;
    PyWinObject_FreeWCHAR(fname);
    Py_XINCREF(ret);
    return ret;
}

// @pyswig |DecryptFile|Decrypts specified file (requires Win2k or higher and NTFS)
static PyObject*
py_DecryptFile(PyObject *self, PyObject *args)
{
	// @pyparm string/unicode|filename||File to decrypt
	PyObject *ret=NULL, *obfname=NULL;
	WCHAR *fname = NULL;
	DWORD reserved=0;
	if (pfnDecryptFile==NULL)
		return PyErr_Format(PyExc_NotImplementedError,"DecryptFile not supported by this version of Windows");
	if (!PyArg_ParseTuple(args,"O:DecryptFile", &obfname))
		return NULL;
	if (!PyWinObject_AsWCHAR(obfname, &fname, FALSE))
		return NULL;
	if (!(*pfnDecryptFile)(fname,reserved))
		PyWin_SetAPIError("DecryptFile");
	else
		ret=Py_None;
	PyWinObject_FreeWCHAR(fname);
	Py_XINCREF(ret);
	return ret;
}

// @pyswig |EncryptionDisable|Enables/disables encryption for a directory (requires Win2k or higher and NTFS)
static PyObject*
py_EncryptionDisable(PyObject *self, PyObject *args)
{
    // @pyparm string/unicode|DirName||Directory to enable or disable
	// @pyparm boolean|Disable||Set to False to enable encryption
    PyObject *ret=NULL, *obfname=NULL;
    WCHAR *fname = NULL;
	BOOL Disable;
	if (pfnEncryptionDisable==NULL)
		return PyErr_Format(PyExc_NotImplementedError,"EncryptionDisable not supported by this version of Windows");
    if (!PyArg_ParseTuple(args,"Oi", &obfname, &Disable))
        return NULL;
    if (!PyWinObject_AsWCHAR(obfname, &fname, FALSE))
        return NULL;
	if (!(*pfnEncryptionDisable)(fname,Disable))
        PyWin_SetAPIError("EncryptionDisable");
    else
        ret=Py_None;
    PyWinObject_FreeWCHAR(fname);
    Py_XINCREF(ret);
    return ret;
}

// @pyswig int|FileEncryptionStatus|retrieves the encryption status of the specified file.
// @rdesc The result is documented as being one of FILE_ENCRYPTABLE,
// FILE_IS_ENCRYPTED, FILE_SYSTEM_ATTR, FILE_ROOT_DIR, FILE_SYSTEM_DIR,
// FILE_UNKNOWN, FILE_SYSTEM_NOT_SUPPORT, FILE_USER_DISALLOWED,
// or FILE_READ_ONLY 
// @comm Requires Windows 2000 or higher.
static PyObject*
py_FileEncryptionStatus(PyObject *self, PyObject *args)
{
    // @pyparm string/unicode|FileName||file to query
    PyObject *ret=NULL, *obfname=NULL;
    WCHAR *fname = NULL;
	DWORD Status=0;
	if (pfnFileEncryptionStatus==NULL)
		return PyErr_Format(PyExc_NotImplementedError,"FileEncryptionStatus not supported by this version of Windows");
    if (!PyArg_ParseTuple(args,"O", &obfname))
        return NULL;
    if (!PyWinObject_AsWCHAR(obfname, &fname, FALSE))
        return NULL;
	if (!(*pfnFileEncryptionStatus)(fname, &Status))
        PyWin_SetAPIError("FileEncryptionStatus");
    else
        ret=Py_BuildValue("i",Status);
    PyWinObject_FreeWCHAR(fname);
    return ret;
}

void PyWinObject_FreePENCRYPTION_CERTIFICATE_LIST(PENCRYPTION_CERTIFICATE_LIST pecl)
{
	DWORD cert_ind=0;
	PENCRYPTION_CERTIFICATE *ppec=NULL;
	if (pecl->pUsers != NULL){
		ppec=pecl->pUsers;
		for (cert_ind=0;cert_ind<pecl->nUsers;cert_ind++){
			if (*ppec != NULL){
				if ((*ppec)->pCertBlob != NULL)
					free ((*ppec)->pCertBlob);
					// don't free PENCRYPTION_CERTIFICATE->pCertBlob->pbData or PENCRYPTION_CERTIFICATE->pUserSid,
					// both have internal pointers from Python string and Sid objects
				free (*ppec);
				}
			ppec++;
			}	
		free(pecl->pUsers);
		}
}

void PyWinObject_FreePENCRYPTION_CERTIFICATE_HASH_LIST(PENCRYPTION_CERTIFICATE_HASH_LIST pechl)
{
	DWORD hash_ind=0;
	PENCRYPTION_CERTIFICATE_HASH *ppech=NULL;
	if (pechl->pUsers != NULL){
		ppech=pechl->pUsers;
		for (hash_ind=0;hash_ind<pechl->nCert_Hash;hash_ind++){
			if (*ppech != NULL){
				// PENCRYPTION_CERTIFICATE_HASH->pHash->pbData and PENCRYPTION_CERTIFICATE_HASH->pUserSid
				// will be freed when corresponding python objects are deallocated
				if ((*ppech)->lpDisplayInformation != NULL)
					PyWinObject_FreeWCHAR((*ppech)->lpDisplayInformation);
				if ((*ppech)->pHash != NULL)
					free ((*ppech)->pHash);
				free (*ppech);
				}
			ppech++;
			}	
		free(pechl->pUsers);
		}
}

PyObject *PyWinObject_FromPENCRYPTION_CERTIFICATE_LIST(PENCRYPTION_CERTIFICATE_LIST pecl)
{
	DWORD user_cnt;
	PENCRYPTION_CERTIFICATE *user_item=NULL;
	PyObject *obsid=NULL, *ret_item=NULL;
	PyObject *ret=PyTuple_New(pecl->nUsers);
	if (!ret){
		PyErr_SetString(PyExc_MemoryError,"PyWinObject_FromPENCRYPTION_CERTIFICATE_LIST: unable to allocate return tuple");
		return NULL;
		}
	user_item=pecl->pUsers;
	for (user_cnt=0; user_cnt < pecl->nUsers; user_cnt++){
		obsid=PyWinObject_FromSID((*user_item)->pUserSid);
		ret_item=Py_BuildValue("Ns#", obsid, (*user_item)->pCertBlob->pbData,(*user_item)->pCertBlob->cbData);
		if (!ret_item){
			PyErr_SetString(PyExc_MemoryError,"PyWinObject_FromPENCRYPTION_CERTIFICATE_LIST: unable to allocate tuple item");
			Py_DECREF(ret);
			return NULL;
			}
		PyTuple_SetItem(ret, user_cnt, ret_item);
		user_item++;
		}
	return ret;
}

PyObject *PyWinObject_FromPENCRYPTION_CERTIFICATE_HASH_LIST(PENCRYPTION_CERTIFICATE_HASH_LIST pechl)
{
	DWORD user_cnt;
	PENCRYPTION_CERTIFICATE_HASH *user_item=NULL;
	PyObject *obsid=NULL, *obDisplayInformation=NULL, *ret_item=NULL;
	PyObject *ret=PyTuple_New(pechl->nCert_Hash);
	if (!ret){
		PyErr_SetString(PyExc_MemoryError,"PyWinObject_FromPENCRYPTION_CERTIFICATE_HASH_LIST: unable to allocate return tuple");
		return NULL;
		}
	user_item=pechl->pUsers;
	for (user_cnt=0; user_cnt < pechl->nCert_Hash; user_cnt++){
		obsid=PyWinObject_FromSID((*user_item)->pUserSid);
		obDisplayInformation=PyWinObject_FromWCHAR((*user_item)->lpDisplayInformation);
		if (!obDisplayInformation){
			Py_DECREF(ret);
			return NULL;
			}
		ret_item=Py_BuildValue("Ns#N", obsid, (*user_item)->pHash->pbData,(*user_item)->pHash->cbData, obDisplayInformation);
		if (!ret_item){
			PyErr_SetString(PyExc_MemoryError,"PyWinObject_FromPENCRYPTION_CERTIFICATE_HASH_LIST: unable to allocate tuple item");
			Py_DECREF(ret);
			return NULL;
			}
		PyTuple_SetItem(ret, user_cnt, ret_item);
		user_item++;
		}
	return ret;
}

BOOL PyWinObject_AsPENCRYPTION_CERTIFICATE_LIST(PyObject *obcert_list, PENCRYPTION_CERTIFICATE_LIST pecl)
{	
	char *format_msg="ENCRYPTION_CERTIFICATE_LIST must be represented as a sequence of sequences of (PySID, str, int dwCertEncodingType )";
	BOOL bSuccess=TRUE;
	DWORD cert_cnt=0, cert_ind=0;
	PENCRYPTION_CERTIFICATE *ppec=NULL;
	PyObject *obcert=NULL;
	PyObject *obsid=NULL, *obcert_member=NULL;

	if (!PySequence_Check(obcert_list)){
		PyErr_SetString(PyExc_TypeError,format_msg);
		return FALSE;
		}
	cert_cnt=PySequence_Length(obcert_list);
	pecl->nUsers=cert_cnt;
	ppec=(PENCRYPTION_CERTIFICATE *)malloc(cert_cnt*sizeof(PENCRYPTION_CERTIFICATE));
	if (ppec==NULL){
		PyErr_SetString(PyExc_MemoryError,"PyWinObject_AsENCRYPTION_CERTIFICATE_LIST: unable to allocate hash list");
		return NULL;
		}
	ZeroMemory(ppec,cert_cnt*sizeof(PENCRYPTION_CERTIFICATE));
	pecl->pUsers=ppec;

	for (cert_ind=0;cert_ind<cert_cnt;cert_ind++){
		obcert=PySequence_GetItem(obcert_list, cert_ind);
		if (!PySequence_Check(obcert)){
			PyErr_SetString(PyExc_TypeError,format_msg);
			bSuccess=FALSE;
			}
		if (bSuccess)
			if (PySequence_Length(obcert)!=3){
				PyErr_SetString(PyExc_TypeError,format_msg);
				bSuccess=FALSE;
				}
		if (bSuccess){
			*ppec=new(ENCRYPTION_CERTIFICATE);
			if (*ppec==NULL){
				PyErr_SetString(PyExc_MemoryError,"PyWinObject_AsENCRYPTION_CERTIFICATE_LIST: unable to allocate ENCRYPTION_CERTIFICATE");
				bSuccess=FALSE;
				}
			}
		if (bSuccess){
			ZeroMemory(*ppec,sizeof(ENCRYPTION_CERTIFICATE));
			(*ppec)->cbTotalLength=sizeof(ENCRYPTION_CERTIFICATE);
			obcert_member=PySequence_GetItem(obcert,0);
			bSuccess=PyWinObject_AsSID(obcert_member, (PSID *)&((*ppec)->pUserSid));
			Py_DECREF(obcert_member);
			}

		if (bSuccess){
			(*ppec)->pCertBlob=new(EFS_CERTIFICATE_BLOB);
			if ((*ppec)->pCertBlob==NULL){
				PyErr_SetString(PyExc_MemoryError,"PyWinObject_AsENCRYPTION_CERTIFICATE_LIST: unable to allocate EFS_CERTIFICATE_BLOB");
				bSuccess=FALSE;
				}
			}
		if (bSuccess){
			ZeroMemory((*ppec)->pCertBlob,sizeof(EFS_CERTIFICATE_BLOB));
			obcert_member=PySequence_GetItem(obcert,1);
			if (!PyInt_Check(obcert_member)){
				PyErr_SetString(PyExc_TypeError,"Second item (dwCertEncodingType) of ENCRYPTION_CERTIFICATE must be an integer");
				bSuccess=FALSE;
				}
			else
				(*ppec)->pCertBlob->dwCertEncodingType=PyInt_AsLong(obcert_member);
			Py_DECREF(obcert_member);
			}

		if (bSuccess){
			obcert_member=PySequence_GetItem(obcert,2);
			if (PyString_AsStringAndSize(obcert_member, 
					(char **)&((*ppec)->pCertBlob->pbData), 
					(int *)  &((*ppec)->pCertBlob->cbData))==-1){
				PyErr_SetString(PyExc_TypeError,"Third item of ENCRYPTION_CERTIFICATE must be a string containing encoded certificate data");
				bSuccess=FALSE;
				}
			Py_DECREF(obcert_member);
			}
		Py_DECREF(obcert);
		if (!bSuccess)
			break;
		ppec++;
		}
	return bSuccess;
}

BOOL PyWinObject_AsPENCRYPTION_CERTIFICATE_HASH_LIST(PyObject *obhash_list, PENCRYPTION_CERTIFICATE_HASH_LIST pechl)
{
	char *err_msg="ENCRYPTION_CERTIFICATE_HASH_LIST must be represented as a sequence of sequences of (PySID, string, unicode)";
	BOOL bSuccess=TRUE;
	DWORD hash_cnt=0, hash_ind=0;
	PENCRYPTION_CERTIFICATE_HASH *ppech=NULL;
	PyObject *obsid=NULL, *obDisplayInformation=NULL, *obhash=NULL;
	PyObject *obhash_item=NULL;

	if (!PySequence_Check(obhash_list)){
		PyErr_SetString(PyExc_TypeError,err_msg);
		return FALSE;
		}
	hash_cnt=PySequence_Length(obhash_list);
	pechl->nCert_Hash=hash_cnt;
	ppech=(PENCRYPTION_CERTIFICATE_HASH *)malloc(hash_cnt*sizeof(PENCRYPTION_CERTIFICATE_HASH));
	if (ppech==NULL){
		PyErr_SetString(PyExc_MemoryError,"PyWinObject_AsENCRYPTION_CERTIFICATE_HASH_LIST: unable to allocate ENCRYPTION_CERTIFICATE_HASH_LIST");
		return FALSE;
		}
	ZeroMemory(ppech,hash_cnt*sizeof(PENCRYPTION_CERTIFICATE_HASH));
	pechl->pUsers=ppech;

	for (hash_ind=0;hash_ind<hash_cnt;hash_ind++){
		obhash=PySequence_GetItem(obhash_list, hash_ind);
		if (!PySequence_Check(obhash)){
			PyErr_SetString(PyExc_TypeError,err_msg);
			bSuccess=FALSE;
			}
		if (bSuccess)
			if (PySequence_Length(obhash)!=3){
				PyErr_SetString(PyExc_TypeError,err_msg);
				bSuccess=FALSE;
				}
		if (bSuccess){
			*ppech=new(ENCRYPTION_CERTIFICATE_HASH);
			if (*ppech==NULL){
				PyErr_SetString(PyExc_MemoryError,"PyWinObject_AsPENCRYPTION_CERTIFICATE_HASH_LIST: unable to allocate EMCRYPTION_CERTIFICATE_HASH");
				bSuccess=FALSE;
				}
			}
		if (bSuccess){
			ZeroMemory(*ppech,sizeof(ENCRYPTION_CERTIFICATE_HASH));
			(*ppech)->cbTotalLength=sizeof(ENCRYPTION_CERTIFICATE_HASH);
			obhash_item=PySequence_GetItem(obhash,0);
			bSuccess=PyWinObject_AsSID(obhash_item, (PSID *)&((*ppech)->pUserSid));
			Py_DECREF(obhash_item);
			}

		if (bSuccess){
			(*ppech)->pHash=new(EFS_HASH_BLOB);
			if ((*ppech)->pHash==NULL){
				PyErr_SetString(PyExc_MemoryError,"PyWinObject_AsPENCRYPTION_CERTIFICATE_HASH_LIST: unable to allocate EFS_HASH_BLOB");
				bSuccess=FALSE;
				}
			}

		if (bSuccess){
			ZeroMemory((*ppech)->pHash,sizeof(EFS_HASH_BLOB));
			obhash_item=PySequence_GetItem(obhash,1);
			if (PyString_AsStringAndSize(obhash_item, 
				(char **)&((*ppech)->pHash->pbData), 
				(int *)  &((*ppech)->pHash->cbData))==-1){
				PyErr_SetString(PyExc_TypeError,"Second item of ENCRYPTION_CERTIFICATE_HASH tuple must be a string containing encoded certificate data");
				bSuccess=FALSE;
				}
			Py_DECREF(obhash_item);
			}

		if (bSuccess){
			obhash_item=PySequence_GetItem(obhash,2);
			bSuccess=PyWinObject_AsWCHAR(obhash_item, &(*ppech)->lpDisplayInformation);
			Py_DECREF(obhash_item);
			}
		Py_DECREF(obhash);
		if (!bSuccess)
			break;
		ppech++;
		}
	return bSuccess;
}


// @pyswig (<o PySID>,string,unicode)|QueryUsersOnEncryptedFile|Returns list of users for an encrypted file as tuples of (SID, certificate hash blob, display info)
static PyObject*
py_QueryUsersOnEncryptedFile(PyObject *self, PyObject *args)
{
    // @pyparm string/unicode|FileName||file to query
	if ((pfnQueryUsersOnEncryptedFile==NULL)||(pfnFreeEncryptionCertificateHashList==NULL))
		return PyErr_Format(PyExc_NotImplementedError,"QueryUsersOnEncryptedFile not supported by this version of Windows");
	PyObject *ret=NULL, *obfname=NULL, *ret_item=NULL;
	WCHAR *fname=NULL;
	DWORD err=0;
	PyObject *obsid=NULL, *obDisplayInformation=NULL;
	PENCRYPTION_CERTIFICATE_HASH_LIST pechl=NULL;

	if (!PyArg_ParseTuple(args,"O:QueryUsersOnEncryptedFile", &obfname))
		return NULL;
	if (!PyWinObject_AsWCHAR(obfname, &fname, FALSE))
		return NULL;

	err=(*pfnQueryUsersOnEncryptedFile)(fname, &pechl);
	if (err != ERROR_SUCCESS)
		PyWin_SetAPIError("QueryUsersOnEncryptedFile",err);
	else
		ret=PyWinObject_FromPENCRYPTION_CERTIFICATE_HASH_LIST(pechl);

	if (fname!=NULL)
		PyWinObject_FreeWCHAR(fname);
	if (pechl!=NULL)
		(*pfnFreeEncryptionCertificateHashList)(pechl);
	return ret;
}

// @pyswig (<o PySID>,string,unicode)|QueryRecoveryAgentsOnEncryptedFile|Lists recovery agents for file as a tuple of tuples.
// @rdesc The result is a tuple of tuples - ((SID, certificate hash blob, display info),....)
static PyObject*
py_QueryRecoveryAgentsOnEncryptedFile(PyObject *self, PyObject *args)
{
    // @pyparm string/unicode|FileName||file to query
	if ((pfnQueryRecoveryAgentsOnEncryptedFile==NULL)||(pfnFreeEncryptionCertificateHashList==NULL))
		return PyErr_Format(PyExc_NotImplementedError,"QueryRecoveryAgentsOnEncryptedFile not supported by this version of Windows");
	PyObject *ret=NULL, *obfname=NULL, *ret_item=NULL;
	WCHAR *fname=NULL;
	DWORD user_cnt=0, err=0;
	PyObject *obsid=NULL, *obDisplayInformation=NULL;
	PENCRYPTION_CERTIFICATE_HASH_LIST pechl=NULL;
	PENCRYPTION_CERTIFICATE_HASH *user_item=NULL;
	if (!PyArg_ParseTuple(args,"O:QueryRecoveryAgentsOnEncryptedFile", &obfname))
		return NULL;
	if (!PyWinObject_AsWCHAR(obfname, &fname, FALSE))
		return NULL;

	err=(*pfnQueryRecoveryAgentsOnEncryptedFile)(fname, &pechl);
	if (err != ERROR_SUCCESS)
		PyWin_SetAPIError("QueryRecoveryAgentsOnEncryptedFile",err);
	else
		ret=PyWinObject_FromPENCRYPTION_CERTIFICATE_HASH_LIST(pechl);

	if (fname!=NULL)
	    PyWinObject_FreeWCHAR(fname);
	if (pechl!=NULL)
		(*pfnFreeEncryptionCertificateHashList)(pechl);
    return ret;
}

// @pyswig |RemoveUsersFromEncryptedFile|Removes specified certificates from file - if certificate is not found, it is ignored
static PyObject*
py_RemoveUsersFromEncryptedFile(PyObject *self, PyObject *args)
{
    // @pyparm string/unicode|FileName||File from which to remove users
	// @pyparm ((<o PySID>,string,unicode),...)|pHashes||Sequence representing an ENCRYPTION_CERTIFICATE_HASH_LIST structure, as returned by QueryUsersOnEncryptedFile
	if (pfnRemoveUsersFromEncryptedFile==NULL)
		return PyErr_Format(PyExc_NotImplementedError,"RemoveUsersFromEncryptedFile not supported by this version of Windows");
	PyObject *ret=NULL, *obfname=NULL, *obechl=NULL;
	WCHAR *fname=NULL;
	DWORD err=0;
	ENCRYPTION_CERTIFICATE_HASH_LIST echl;
	ZeroMemory(&echl,sizeof(ENCRYPTION_CERTIFICATE_HASH_LIST));
	if (!PyArg_ParseTuple(args,"OO:RemoveUsersFromEncryptedFile", &obfname, &obechl))
		return NULL;
	if (!PyWinObject_AsWCHAR(obfname, &fname, FALSE))
		return NULL;
	if (!PyWinObject_AsPENCRYPTION_CERTIFICATE_HASH_LIST(obechl,&echl))
		goto done;

	err=(*pfnRemoveUsersFromEncryptedFile)(fname, &echl);
	if (err != ERROR_SUCCESS)
		PyWin_SetAPIError("RemoveUsersFromEncryptedFile",err);
	else
		ret=Py_None;
	done:
	PyWinObject_FreePENCRYPTION_CERTIFICATE_HASH_LIST(&echl);
	if (fname!=NULL)
		PyWinObject_FreeWCHAR(fname);
	Py_XINCREF(ret);
    return ret;
}

// @pyswig |AddUsersToEncryptedFile|Allows user identified by SID and EFS certificate access to decrypt specified file
static PyObject*
py_AddUsersToEncryptedFile(PyObject *self, PyObject *args)
{
	// @pyparm string/unicode|FileName||File that additional users will be allowed to decrypt
	// @pyparm ((<o PySID>,string,int),...)|pUsers||Sequence representing
	// ENCRYPTION_CERTIFICATE_LIST - elements are sequences consisting of
	// users' Sid, encoded EFS certficate (user must export a .cer to obtain
	// this data), and encoding type (usually 1 for X509_ASN_ENCODING)
	if (pfnAddUsersToEncryptedFile==NULL)
		return PyErr_Format(PyExc_NotImplementedError,"AddUsersToEncryptedFile not supported by this version of Windows");
	PyObject *ret=NULL, *obfname=NULL, *obecl=NULL;
	WCHAR *fname=NULL;
	DWORD err=0;
	ENCRYPTION_CERTIFICATE_LIST ecl;
	ZeroMemory(&ecl,sizeof(ENCRYPTION_CERTIFICATE_LIST));
	if (!PyArg_ParseTuple(args,"OO:AddUsersToEncryptedFile", &obfname, &obecl))
		return NULL;
	if (!PyWinObject_AsWCHAR(obfname, &fname, FALSE))
		return NULL;
	if (!PyWinObject_AsPENCRYPTION_CERTIFICATE_LIST(obecl,&ecl))
		return NULL;

	err=(*pfnAddUsersToEncryptedFile)(fname, &ecl);
	if (err != ERROR_SUCCESS)
		PyWin_SetAPIError("AddUsersToEncryptedFile",err);
	else
		ret=Py_None;
	if (fname!=NULL)
	    PyWinObject_FreeWCHAR(fname);
	PyWinObject_FreePENCRYPTION_CERTIFICATE_LIST(&ecl);
	Py_XINCREF(ret);
    return ret;
}

// @pyswig (int, buffer, int)|BackupRead|Reads streams of data from a file
// @comm Returns number of bytes read, data buffer, and context pointer for next operation
// If Buffer is None, a new buffer will be created of size NbrOfBytesToRead that can be passed
//	back in subsequent calls

static PyObject*
py_BackupRead(PyObject *self, PyObject *args)
{
	CHECK_PFN(BackupRead);
	// @pyparm <o PyHANDLE>|hFile||File handle opened by CreateFile
	// @pyparm int|NumberOfBytesToRead||Number of bytes to be read from file
	// @pyparm buffer|Buffer||Writeable buffer object that receives data read
	// @pyparm int|bAbort||If true, ends read operation and frees backup context
	// @pyparm int|bProcessSecurity||Indicates whether file's ACL stream should be read
	// @pyparm int|lpContext||Pass 0 on first call, then pass back value returned from last call thereafter
	HANDLE h;
	BYTE *buf;
	int buflen;
	DWORD bytes_requested, bytes_read;
	BOOL bAbort,bProcessSecurity;
	LPVOID ctxt;
	PyObject *obbuf=NULL, *obbufout=NULL;

	if (!PyArg_ParseTuple(args, "llOlll", &h, &bytes_requested, &obbuf, &bAbort, &bProcessSecurity, &ctxt))
		return NULL;
	if (obbuf==Py_None){
		obbufout=PyBuffer_New(bytes_requested); // ??? any way to create a writable buffer from Python level ???
		if (obbufout==NULL)
			return NULL;
		if (PyObject_AsWriteBuffer(obbufout, (void **)&buf, &buflen)==-1){
			Py_DECREF(obbufout);
			return NULL;
			}
		}
	else{
		obbufout=obbuf;
		if (PyObject_AsWriteBuffer(obbufout, (void **)&buf, &buflen)==-1)
			return NULL;
		if ((DWORD)buflen < bytes_requested)
			return PyErr_Format(PyExc_ValueError,"Buffer size (%d) less than requested read size (%d)", buflen, bytes_requested);
		Py_INCREF(obbufout);
		}
	if (!(*pfnBackupRead)(h, buf, bytes_requested, &bytes_read, bAbort, bProcessSecurity, &ctxt)){
		PyWin_SetAPIError("BackupRead");
		Py_DECREF(obbufout);
		return NULL;
		}
	return Py_BuildValue("lNl", bytes_read, obbufout, ctxt);
}

// @pyswig long|BackupSeek|Seeks forward in a file stream
// @comm Function will only seek to end of current stream, used to seek past bad data
//    or find beginning position for read of next stream
// Returns number of bytes actually moved
static PyObject*
py_BackupSeek(PyObject *self, PyObject *args)
{
	CHECK_PFN(BackupSeek);
	// @pyparm <o PyHANDLE>|hFile||File handle used by a BackupRead operation
	// @pyparm long|NumberOfBytesToSeek||Number of bytes to move forward in current stream
	// @pyparm int|lpContext||Context pointer returned from a BackupRead operation
	HANDLE h;
	ULARGE_INTEGER bytes_to_seek;
	ULARGE_INTEGER bytes_moved;
	LPVOID ctxt;
	PyObject *obbytes_to_seek;
	if (!PyArg_ParseTuple(args,"lOl", &h, &obbytes_to_seek, &ctxt))
		return NULL;
	if (!PyWinObject_AsULARGE_INTEGER(obbytes_to_seek, &bytes_to_seek))
		return NULL;
	bytes_moved.QuadPart=0;
	if (!(*pfnBackupSeek)(h, bytes_to_seek.LowPart, bytes_to_seek.HighPart, 
	                   &bytes_moved.LowPart, &bytes_moved.HighPart,
	                   &ctxt)){
	    // function returns false if you attempt to seek past end of current stream, but file pointer
	    //   still moves to start of next stream - consider this as success
		if (bytes_moved.QuadPart==0){
			PyWin_SetAPIError("BackupSeek");
			return NULL;
			}
		}
	return PyWinObject_FromULARGE_INTEGER(bytes_moved);
}

// @pyswig (int,int)|BackupWrite|Restores file data
// @comm Returns number of bytes written and context pointer for next operation
static PyObject*
py_BackupWrite(PyObject *self, PyObject *args)
{
	CHECK_PFN(BackupWrite);
	// @pyparm <o PyHANDLE>|hFile||File handle opened by CreateFile
	// @pyparm int|NumberOfBytesToWrite||Length of data to be written to file
	// @pyparm string|Buffer||A string or buffer object that contains the data to be written
	// @pyparm int|bAbort||If true, ends write operation and frees backup context
	// @pyparm int|bProcessSecurity||Indicates whether ACL's should be restored
	// @pyparm int|lpContext||Pass 0 on first call, then pass back value returned from last call thereafter
	HANDLE h;
	BYTE *buf;
	int buflen;
	DWORD bytes_to_write, bytes_written;
	BOOL bAbort, bProcessSecurity;
	LPVOID ctxt;
	PyObject *obbuf;

	if (!PyArg_ParseTuple(args, "llOlll", &h, &bytes_to_write, &obbuf, &bAbort, &bProcessSecurity, &ctxt))
		return NULL;
	if (PyObject_AsReadBuffer(obbuf, (const void **)&buf, &buflen)==-1)
		return NULL;
	if ((DWORD)buflen < bytes_to_write)
		return PyErr_Format(PyExc_ValueError,"Buffer size (%d) less than requested write size (%d)", buflen, bytes_to_write);

	if (!(*pfnBackupWrite)(h, buf, bytes_to_write, &bytes_written, bAbort, bProcessSecurity, &ctxt)){
		PyWin_SetAPIError("BackupWrite");
		return NULL;
		}
	return Py_BuildValue("ll", bytes_written, ctxt);
}

// @pyswig |SetFileShortName|Set the 8.3 name of a file
// @comm This function is only available on WinXP and later
// @comm File handle must be opened with FILE_FLAG_BACKUP_SEMANTICS, and SE_RESTORE_NAME privilege must be enabled
static PyObject*
py_SetFileShortName(PyObject *self, PyObject *args)
{
	CHECK_PFN(SetFileShortName);
	HANDLE h;
	WCHAR *shortname=NULL;
	PyObject *obh, *obshortname;
	BOOL bsuccess;
	if (!PyArg_ParseTuple(args, "OO:SetFileShortName",
		&obh,			// @pyparm <o PyHANDLE>|hFile||Handle to a file or directory
		&obshortname))	// @pyparm <o PyUNICODE>|ShortName||The 8.3 name to be applied to the file
		return NULL;
	if (!PyWinObject_AsHANDLE(obh, &h, FALSE))
		return NULL;
	if (!PyWinObject_AsWCHAR(obshortname, &shortname, FALSE))
		return NULL;
	Py_BEGIN_ALLOW_THREADS
	bsuccess=(*pfnSetFileShortName)(h, (LPCWSTR)shortname);
	Py_END_ALLOW_THREADS
	PyWinObject_FreeWCHAR(shortname);
	if (bsuccess){
		Py_INCREF(Py_None);
		return Py_None;
		}
	return PyWin_SetAPIError("SetFileShortName");
}

// @object CopyProgressRoutine|Python function used as a callback for <om win32file.CopyFileEx> and <om win32file.MoveFileWithProgress><nl>
// Function will receive 9 parameters:<nl>
// (TotalFileSize, TotalBytesTransferred, StreamSize, StreamBytesTransferred,
//  StreamNumber, CallbackReason, SourceFile, DestinationFile)<nl>
// SourceFile and DestinationFile are <o PyHANDLE>s, all others are longs.<nl>
// CallbackReason will be one of CALLBACK_CHUNK_FINISHED or CALLBACK_STREAM_SWITCH<nl>
// Your implementation of this function must return one of the PROGRESS_* constants.
DWORD CALLBACK CopyFileEx_ProgressRoutine(
  LARGE_INTEGER TotalFileSize,
  LARGE_INTEGER TotalBytesTransferred,
  LARGE_INTEGER StreamSize,
  LARGE_INTEGER StreamBytesTransferred,
  DWORD dwStreamNumber,
  DWORD dwCallbackReason,
  HANDLE hSourceFile,
  HANDLE hDestinationFile,
  LPVOID lpData)
{
	PyObject *args=NULL, *hsrc=NULL, *hdst=NULL, *ret=NULL;
	DWORD retcode;
	CEnterLeavePython _celp;
	PyObject **callback_objects=(PyObject **)lpData;
	hsrc=PyWinObject_FromHANDLE(hSourceFile);
	hdst=PyWinObject_FromHANDLE(hDestinationFile);
	// Py_BuildValue should catch PyHANDLEs NULL
	args=Py_BuildValue("LLLLkkOOO", 
		TotalFileSize, TotalBytesTransferred,
		StreamSize, StreamBytesTransferred,
		dwStreamNumber, dwCallbackReason,
		hsrc, hdst, callback_objects[1]);
	if (args==NULL)	// Some serious error, cancel operation.
		retcode=PROGRESS_CANCEL;
	else{
		ret=PyObject_Call(callback_objects[0], args, NULL);
		if (ret==NULL)
			retcode=PROGRESS_CANCEL;
		else{
			retcode=PyInt_AsLong(ret);
			if (PyErr_Occurred())
				retcode=PROGRESS_CANCEL;
			}
		}

	Py_XDECREF(args);
	Py_XDECREF(ret);
	// Detach PyHANDLEs so they don't prematurely close file handles when destroyed
	if (hsrc!=NULL){
		ret=PyObject_CallMethod(hsrc,"Detach",NULL);
		Py_DECREF(hsrc);
		Py_XDECREF(ret);
		}
	if (hdst!=NULL){
		ret=PyObject_CallMethod(hdst,"Detach",NULL);
		Py_DECREF(hdst);
		Py_XDECREF(ret);
		}
	return retcode;
}

// @pyswig |CopyFileEx|Restartable file copy with optional progress routine
static PyObject*
py_CopyFileEx(PyObject *self, PyObject *args)
{
	CHECK_PFN(CopyFileEx);
	PyObject *obsrc, *obdst, *obcallback=Py_None, *obdata=Py_None, *ret=NULL;
	WCHAR *src=NULL, *dst=NULL;
	BOOL bcancel, bsuccess;
	LPPROGRESS_ROUTINE callback=NULL;
	LPVOID callback_data=NULL;
	PyObject *callback_objects[2];
	DWORD flags=0;
	if (!PyArg_ParseTuple(args, "OO|OOik:CopyFileEx",
		&obsrc,		// @pyparm <o PyUNICODE>|ExistingFileName||File to be copied
		&obdst,		// @pyparm <o PyUNICODE>|NewFileName||Place to which it will be copied
		&obcallback,	// @pyparm <o CopyProgressRoutine>|ProgressRoutine|None|A python function that receives progress updates, can be None
		&obdata,		// @pyparm object|Data|None|An arbitrary object to be passed to the callback function
		&bcancel,		// @pyparm boolean|Cancel|False|Pass True to cancel a restartable copy that was previously interrupted
		&flags))	// @pyparm int|CopyFlags|0|Combination of COPY_FILE_* flags
		return NULL;

	if (obcallback!=Py_None){
		if (!PyCallable_Check(obcallback)){
			PyErr_SetString(PyExc_TypeError,"ProgressRoutine must be callable");
			return NULL;
			}
		callback=CopyFileEx_ProgressRoutine;
		callback_objects[0]=obcallback;
		callback_objects[1]=obdata;
		callback_data=callback_objects;
		}

	if (PyWinObject_AsWCHAR(obsrc, &src, FALSE) && PyWinObject_AsWCHAR(obdst, &dst, FALSE)){
		Py_BEGIN_ALLOW_THREADS
		bsuccess=(*pfnCopyFileEx)(src, dst, callback, callback_data, &bcancel, flags);
		Py_END_ALLOW_THREADS
		if (!bsuccess){
			// progress routine may have already thrown an exception
			if (!PyErr_Occurred())
				PyWin_SetAPIError("CopyFileEx");
			}
		else{
			Py_INCREF(Py_None);
			ret=Py_None;
			}
		}
	PyWinObject_FreeWCHAR(src);
	PyWinObject_FreeWCHAR(dst);
	return ret;
}

// @pyswig |MoveFileWithProgress|Moves a file, and reports progress to a callback function
// @comm Only available on Windows 2000 or later
static PyObject*
py_MoveFileWithProgress(PyObject *self, PyObject *args)
{
	CHECK_PFN(MoveFileWithProgress);
	PyObject *obsrc, *obdst, *obcallback=Py_None, *obdata=Py_None, *ret=NULL;
	WCHAR *src=NULL, *dst=NULL;
	BOOL bsuccess;
	LPPROGRESS_ROUTINE callback=NULL;
	LPVOID callback_data=NULL;
	PyObject *callback_objects[2];
	DWORD flags=0;
	if (!PyArg_ParseTuple(args, "OO|OOk:MoveFileWithProgress",
		&obsrc,		// @pyparm <o PyUNICODE>|ExistingFileName||File or directory to be moved
		&obdst,		// @pyparm <o PyUNICODE>|NewFileName||Destination, can be None if flags contain MOVEFILE_DELAY_UNTIL_REBOOT
		&obcallback,	// @pyparm <o CopyProgressRoutine>|ProgressRoutine|None|A python function that receives progress updates, can be None
		&obdata,	// @pyparm object|Data|None|An arbitrary object to be passed to the callback function
		&flags))	// @pyparm int|Flags|0|Combination of MOVEFILE_* flags
		return NULL;

	if (obcallback!=Py_None){
		if (!PyCallable_Check(obcallback)){
			PyErr_SetString(PyExc_TypeError,"ProgressRoutine must be callable");
			return NULL;
			}
		callback=CopyFileEx_ProgressRoutine;
		callback_objects[0]=obcallback;
		callback_objects[1]=obdata;
		callback_data=callback_objects;
		}

	if (PyWinObject_AsWCHAR(obsrc, &src, FALSE) && PyWinObject_AsWCHAR(obdst, &dst, TRUE)){
		Py_BEGIN_ALLOW_THREADS
		bsuccess=(*pfnMoveFileWithProgress)(src, dst, callback, callback_data, flags);
		Py_END_ALLOW_THREADS
		if (!bsuccess){
			// progress routine may have already thrown an exception
			if (!PyErr_Occurred())
				PyWin_SetAPIError("MoveFileWithProgress");
			}
		else{
			Py_INCREF(Py_None);
			ret=Py_None;
			}
		}
	PyWinObject_FreeWCHAR(src);
	PyWinObject_FreeWCHAR(dst);
	return ret;
}

// @pyswig |ReplaceFile|Replaces one file with another
// @comm Only available on Windows 2000 or later
static PyObject*
py_ReplaceFile(PyObject *self, PyObject *args)
{
	CHECK_PFN(ReplaceFile);
	PyObject *obsrc, *obdst, *obbackup=Py_None, *obExclude=Py_None, *obReserved=Py_None, *ret=NULL;
	WCHAR *src=NULL, *dst=NULL, *backup=NULL;
	LPVOID Exclude=NULL, Reserved=NULL;
	BOOL bsuccess;
	DWORD flags=0;
	if (!PyArg_ParseTuple(args, "OO|OkOO:ReplaceFile",
		&obdst,		// @pyparm <o PyUNICODE>|ReplacedFileName||File to be replaced
		&obsrc,		// @pyparm <o PyUNICODE>|ReplacementFileName||File that will replace it
		&obbackup,	// @pyparm <o PyUNICODE>|BackupFileName|None|Place at which to create a backup of the replaced file, can be None
		&flags,		// @pyparm int|ReplaceFlags|0|Combination of REPLACEFILE_* flags
		&obExclude,	// @pyparm None|Exclude|None|Reserved, use None if passed in
		&obReserved))	// @pyparm None|Reserved|None|Reserved, use None if passed in
		return NULL;

	if (obExclude!=Py_None || obReserved!=Py_None){
		PyErr_SetString(PyExc_ValueError,"Exclude and Reserved must be None");
		return NULL;
		}
	if (PyWinObject_AsWCHAR(obsrc, &dst, FALSE) 
		&&PyWinObject_AsWCHAR(obdst, &src, FALSE)
		&&PyWinObject_AsWCHAR(obbackup, &backup, TRUE)){
		Py_BEGIN_ALLOW_THREADS
		bsuccess=(*pfnReplaceFile)(dst, src, backup, flags, Exclude, Reserved);
		Py_END_ALLOW_THREADS
		if (bsuccess){
			Py_INCREF(Py_None);
			ret=Py_None;
			}
		else
			PyWin_SetAPIError("ReplaceFile");
		}
	PyWinObject_FreeWCHAR(dst);
	PyWinObject_FreeWCHAR(src);
	PyWinObject_FreeWCHAR(backup);
	return ret;
}

void encryptedfilecontextdestructor(void *ctxt){
	if (pfnCloseEncryptedFileRaw)
		(*pfnCloseEncryptedFileRaw)(ctxt);
}

// @pyswig PyCObject|OpenEncryptedFileRaw|Initiates a backup or restore operation on an encrypted file
// @rdesc Returns a PyCObject containing an operation context that can be passed to 
// <om win32file.ReadEncryptedFileRaw> or <om win32file.WriteEncryptedFileRaw>.  Context must be
// destroyed using <om win32file.CloseEncryptedFileRaw>.
// @comm Only available on Windows 2000 or later
static PyObject*
py_OpenEncryptedFileRaw(PyObject *self, PyObject *args)
{
	CHECK_PFN(OpenEncryptedFileRaw);
	CHECK_PFN(CloseEncryptedFileRaw);
	PyObject *obfname, *ret=NULL;
	DWORD flags, err;
	WCHAR *fname=NULL;
	void *ctxt;
	if (!PyArg_ParseTuple(args, "Ok:OpenEncryptedFileRaw",
		&obfname,	// @pyparm <o PyUNICODE>|FileName||Name of file on which to operate
		&flags))	// @pyparm int|Flags||CREATE_FOR_IMPORT, CREATE_FOR_DIR, OVERWRITE_HIDDEN, or 0 for export
		return NULL;
	if (!PyWinObject_AsWCHAR(obfname, &fname, FALSE))
		return NULL;
	Py_BEGIN_ALLOW_THREADS
	err=(*pfnOpenEncryptedFileRaw)(fname, flags, &ctxt),
	Py_END_ALLOW_THREADS
	if (err!=ERROR_SUCCESS)
		PyWin_SetAPIError("OpenEncryptedFileRaw", err);
	else{
		ret=PyCObject_FromVoidPtr(ctxt, encryptedfilecontextdestructor); 
		if (ret==NULL)
			(*pfnCloseEncryptedFileRaw)(ctxt);
		}
	PyWinObject_FreeWCHAR(fname);
	return ret;
}

// @object ExportCallback|User-defined callback function used with <om win32file.ReadEncryptedFileRaw>.<nl>
// Function is called with 3 parameters: (Data, CallbackContext, Length)<nl>
// &nbsp&nbsp Data: Read-only buffer containing the raw data read from the file.  Must not be referenced outside of the callback function.<nl>
// &nbsp&nbsp CallbackContext: Arbitrary object passed to ReadEncryptedFileRaw.<nl>
// &nbsp&nbsp Length: Number of bytes in the Data buffer.<nl>
// On success, function should return ERROR_SUCCESS.  Otherwise, it can return a win32 error code, or simply raise an exception.
DWORD WINAPI PyExportCallback(PBYTE file_data, PVOID callback_data, ULONG length)
{
	CEnterLeavePython _celp;
	PyObject *args=NULL, *ret=NULL;
	DWORD retcode;
	PyObject **callback_objects=(PyObject **)callback_data;
	PyObject *obfile_data=PyBuffer_FromMemory(file_data, length);
	if (obfile_data==NULL)
		retcode=ERROR_OUTOFMEMORY;
	else{
		args=Py_BuildValue("OOk", obfile_data, callback_objects[1], length);
		if (args==NULL)	// exception already set, return any error code
			retcode=ERROR_OUTOFMEMORY;
		else{
			ret=PyObject_Call(callback_objects[0], args, NULL);
			if (ret==NULL)
				retcode=ERROR_OUTOFMEMORY;	// specific code shouldn't matter
			else
				retcode=PyLong_AsUnsignedLong(ret);
			}
		}
	Py_XDECREF(ret);
	Py_XDECREF(args);
	Py_XDECREF(obfile_data);
	return retcode;
}

// @pyswig |ReadEncryptedFileRaw|Reads the encrypted bytes of a file for backup and restore purposes
// @comm Only available on Windows 2000 or later
static PyObject*
py_ReadEncryptedFileRaw(PyObject *self, PyObject *args)
{
	CHECK_PFN(ReadEncryptedFileRaw);
	PyObject *obcallback, *obcallback_data, *obctxt;
	PVOID ctxt;
	PyObject *callback_objects[2];
	DWORD retcode;
	if (!PyArg_ParseTuple(args, "OOO:ReadEncryptedFileRaw",
		&obcallback,		// @pyparm <o ExportCallBack>|ExportCallback||Python function that receives chunks of data as it is read
		&obcallback_data,	// @pyparm object|CallbackContext||Arbitrary Python object to be passed to callback function
		&obctxt))			// @pyparm PyCObject|Context||Context object returned from <om win32file.OpenEncryptedFileRaw>
		return NULL;
	ctxt=PyCObject_AsVoidPtr(obctxt);
	if (ctxt==NULL)
		return NULL;
	if (!PyCallable_Check(obcallback)){
		PyErr_SetString(PyExc_TypeError,"ExportCallback must be callable");
		return NULL;
		}
	callback_objects[0]=obcallback;
	callback_objects[1]=obcallback_data;

	Py_BEGIN_ALLOW_THREADS
	retcode=(*pfnReadEncryptedFileRaw)(PyExportCallback, callback_objects, ctxt);
	Py_END_ALLOW_THREADS
	if (retcode==ERROR_SUCCESS){
		Py_INCREF(Py_None);
		return Py_None;
		}
	// Don't overwrite any error that callback may have thrown
	if (!PyErr_Occurred())
		PyWin_SetAPIError("ReadEncryptedFileRaw",retcode);
	return NULL;
}

// @object ImportCallback|User-defined callback function used with <om win32file.WriteEncryptedFileRaw><nl>
// Function is called with 3 parameters: (Data, CallbackContext, Length)<nl>
// &nbsp&nbsp Data: Writeable buffer to be filled with raw encrypted data.  Buffer memory is only valid within the callback function.<nl>
// &nbsp&nbsp CallbackContext: The arbitrary object passed to WriteEncryptedFileRaw.<nl>
// &nbsp&nbsp Length: Size of the data buffer.<nl>
// Your implementation of this function should return a tuple of 2 ints containing
// an error code (ERROR_SUCCESS on success), and the length of data written to the buffer.<nl>
// Function exits when 0 is returned for the data length.
DWORD WINAPI PyImportCallback(PBYTE file_data, PVOID callback_data, PULONG plength)
{
	CEnterLeavePython _celp;
	PyObject *args=NULL, *ret=NULL;
	DWORD retcode;
	PyObject **callback_objects=(PyObject **)callback_data;
	PyObject *obfile_data=PyBuffer_FromReadWriteMemory(file_data, *plength);
	if (obfile_data==NULL)
		retcode=ERROR_OUTOFMEMORY;
	else{
		args=Py_BuildValue("OOk", obfile_data, callback_objects[1], *plength);
		if (args==NULL)
			retcode=ERROR_OUTOFMEMORY;
		else{
			ret=PyObject_Call(callback_objects[0], args, NULL);
			if (ret==NULL)
				retcode=ERROR_OUTOFMEMORY;
			else if ((!PyTuple_Check(ret)) || (PyTuple_GET_SIZE(ret)!=2)){
				PyErr_SetString(PyExc_TypeError,"ImportCallback must return a tuple of 2 ints");
				retcode=ERROR_OUTOFMEMORY;	// doesn't matter which error code if exception is set
				}
			else if (!PyArg_ParseTuple(ret,"kk", &retcode, plength))
					retcode=ERROR_OUTOFMEMORY;
			}
		}
	Py_XDECREF(ret);
	Py_XDECREF(args);
	Py_XDECREF(obfile_data);
	return retcode;
}

// @pyswig |WriteEncryptedFileRaw|Writes raw bytes to an encrypted file
// @comm Only available on Windows 2000 or later
static PyObject*
py_WriteEncryptedFileRaw(PyObject *self, PyObject *args)
{
	CHECK_PFN(WriteEncryptedFileRaw);
	PyObject *obcallback, *obcallback_data, *obctxt;
	PVOID ctxt;
	PyObject *callback_objects[2];
	DWORD retcode;
	if (!PyArg_ParseTuple(args, "OOO:WriteEncryptedFileRaw",
		&obcallback,		// @pyparm <o ImportCallBack>|ImportCallback||Python function that supplies data to be written
		&obcallback_data,	// @pyparm object|CallbackContext||Arbitrary Python object to be passed to callback function
		&obctxt))			// @pyparm PyCObject|Context||Context object returned from <om win32file.OpenEncryptedFileRaw>
		return NULL;
	ctxt=PyCObject_AsVoidPtr(obctxt);
	if (ctxt==NULL)
		return NULL;
	if (!PyCallable_Check(obcallback)){
		PyErr_SetString(PyExc_TypeError,"ExportCallback must be callable");
		return NULL;
		}
	callback_objects[0]=obcallback;
	callback_objects[1]=obcallback_data;

	Py_BEGIN_ALLOW_THREADS
	retcode=(*pfnWriteEncryptedFileRaw)(PyImportCallback, callback_objects, ctxt);
	Py_END_ALLOW_THREADS
	if (retcode==ERROR_SUCCESS){
		Py_INCREF(Py_None);
		return Py_None;
		}
	// Don't overwrite any error that callback may have thrown
	if (!PyErr_Occurred())
		PyWin_SetAPIError("WriteEncryptedFileRaw",retcode);
	return NULL;
}

// @pyswig |CloseEncryptedFileRaw|Frees a context created by <om win32file.OpenEncryptedFileRaw>
// @comm Only available on Windows 2000 or later
static PyObject*
py_CloseEncryptedFileRaw(PyObject *self, PyObject *args)
{
	CHECK_PFN(CloseEncryptedFileRaw);
	PyObject *obctxt;
	PVOID ctxt;
	if (!PyArg_ParseTuple(args, "O:CloseEncryptedFileRaw",
		&obctxt))	// @pyparm PyCObject|Context||Context object returned from <om win32file.OpenEncryptedFileRaw>
		return NULL;
	ctxt=PyCObject_AsVoidPtr(obctxt);
	if (ctxt==NULL)
		return NULL;
	// function has no return value, make sure to check for memory leaks!
	(*pfnCloseEncryptedFileRaw)(ctxt);
	Py_INCREF(Py_None);
	return Py_None;
}
%}

%native (SetVolumeMountPoint) py_SetVolumeMountPoint;
%native (DeleteVolumeMountPoint) py_DeleteVolumeMountPoint;
%native (CreateHardLink) py_CreateHardLink;
%native (GetVolumeNameForVolumeMountPoint) py_GetVolumeNameForVolumeMountPoint;
%native (GetVolumePathName) py_GetVolumePathName;

// end of win2k volume mount functions.
%native (EncryptFile) py_EncryptFile;
%native (DecryptFile) py_DecryptFile;
%native (EncryptionDisable) py_EncryptionDisable;
%native (FileEncryptionStatus) py_FileEncryptionStatus;
%native (QueryUsersOnEncryptedFile) py_QueryUsersOnEncryptedFile;
%native (QueryRecoveryAgentsOnEncryptedFile) py_QueryRecoveryAgentsOnEncryptedFile;
%native (RemoveUsersFromEncryptedFile) py_RemoveUsersFromEncryptedFile;
%native (AddUsersToEncryptedFile) py_AddUsersToEncryptedFile;
%native (BackupRead) py_BackupRead;
%native (BackupSeek) py_BackupSeek;
%native (BackupWrite) py_BackupWrite;
%native (SetFileShortName) py_SetFileShortName;
%native (CopyFileEx) py_CopyFileEx;
%native (MoveFileWithProgress) py_MoveFileWithProgress;
%native (ReplaceFile) py_ReplaceFile;
%native (OpenEncryptedFileRaw) py_OpenEncryptedFileRaw;
%native (ReadEncryptedFileRaw) py_ReadEncryptedFileRaw;
%native (WriteEncryptedFileRaw) py_WriteEncryptedFileRaw;
%native (CloseEncryptedFileRaw) py_CloseEncryptedFileRaw;

%init %{

	PyDict_SetItemString(d, "error", PyWinExc_ApiError);

	HMODULE hmodule;
	FARPROC fp;

	hmodule=LoadLibrary("AdvAPI32.dll");
	if (hmodule){
		fp=GetProcAddress(hmodule,"EncryptFileW");
		if (fp) pfnEncryptFile=(BOOL (WINAPI *)(WCHAR *))(fp);

		fp=GetProcAddress(hmodule,"DecryptFileW");
		if (fp) pfnDecryptFile=(BOOL (WINAPI *)(WCHAR *, DWORD))(fp);

		fp=GetProcAddress(hmodule,"EncryptionDisable");
		if (fp) pfnEncryptionDisable=(BOOL (WINAPI *)(WCHAR *, BOOL))(fp);

		fp=GetProcAddress(hmodule,"FileEncryptionStatusW");
		if (fp) pfnFileEncryptionStatus=(BOOL (WINAPI *)(WCHAR *, LPDWORD))(fp);

		fp=GetProcAddress(hmodule,"QueryUsersOnEncryptedFile");
		if (fp) pfnQueryUsersOnEncryptedFile=(DWORD (WINAPI *)(WCHAR *, PENCRYPTION_CERTIFICATE_HASH_LIST *))(fp);

		fp=GetProcAddress(hmodule,"FreeEncryptionCertificateHashList");
		if (fp) pfnFreeEncryptionCertificateHashList=(BOOL (WINAPI *)(PENCRYPTION_CERTIFICATE_HASH_LIST))(fp);

		fp=GetProcAddress(hmodule,"QueryRecoveryAgentsOnEncryptedFile");
		if (fp) pfnQueryRecoveryAgentsOnEncryptedFile=(DWORD (WINAPI *)(WCHAR *,PENCRYPTION_CERTIFICATE_HASH_LIST *))(fp);

		fp=GetProcAddress(hmodule,"RemoveUsersFromEncryptedFile");
		if (fp) pfnRemoveUsersFromEncryptedFile=(DWORD (WINAPI *)(WCHAR *,PENCRYPTION_CERTIFICATE_HASH_LIST))(fp);

		fp=GetProcAddress(hmodule,"AddUsersToEncryptedFile");
		if (fp) pfnAddUsersToEncryptedFile=(DWORD (WINAPI *)(WCHAR *,PENCRYPTION_CERTIFICATE_LIST))(fp);

		pfnOpenEncryptedFileRaw=(OpenEncryptedFileRawfunc)GetProcAddress(hmodule, "OpenEncryptedFileRawW");
		pfnReadEncryptedFileRaw=(ReadEncryptedFileRawfunc)GetProcAddress(hmodule, "ReadEncryptedFileRaw");
		pfnWriteEncryptedFileRaw=(WriteEncryptedFileRawfunc)GetProcAddress(hmodule, "WriteEncryptedFileRaw");
		pfnCloseEncryptedFileRaw=(CloseEncryptedFileRawfunc)GetProcAddress(hmodule, "CloseEncryptedFileRaw");
		}

	hmodule = GetModuleHandle("kernel32.dll");
	if (hmodule){
		fp = GetProcAddress(hmodule, "GetVolumeNameForVolumeMountPointW");
		if (fp) pfnGetVolumeNameForVolumeMountPointW = (BOOL (WINAPI *)(LPCWSTR, LPCWSTR, DWORD))(fp);

		fp = GetProcAddress(hmodule, "GetVolumePathNameW");
		if (fp) pfnGetVolumePathNameW = (BOOL (WINAPI *)(WCHAR *, WCHAR *, DWORD))(fp);

		fp = GetProcAddress(hmodule, "SetVolumeMountPointW");
		if (fp) pfnSetVolumeMountPointW = (BOOL (WINAPI *)(LPCWSTR, LPCWSTR))(fp);

		fp = GetProcAddress(hmodule, "DeleteVolumeMountPointW");
		if (fp) pfnDeleteVolumeMountPointW = (BOOL (WINAPI *)(LPCWSTR))(fp);

		fp = GetProcAddress(hmodule, "CreateHardLinkW");
		if (fp) pfnCreateHardLinkW = (BOOL (WINAPI *)(LPCWSTR, LPCWSTR, LPSECURITY_ATTRIBUTES))(fp);
	
		pfnBackupRead=(BackupReadfunc)GetProcAddress(hmodule,"BackupRead");
		pfnBackupSeek=(BackupSeekfunc)GetProcAddress(hmodule,"BackupSeek");
		pfnBackupWrite=(BackupWritefunc)GetProcAddress(hmodule,"BackupWrite");
		pfnSetFileShortName=(SetFileShortNamefunc)GetProcAddress(hmodule,"SetFileShortNameW");
		pfnCopyFileEx=(CopyFileExfunc)GetProcAddress(hmodule,"CopyFileExW");
		pfnMoveFileWithProgress=(MoveFileWithProgressfunc)GetProcAddress(hmodule,"MoveFileWithProgressW");
		pfnReplaceFile=(ReplaceFilefunc)GetProcAddress(hmodule,"ReplaceFileW");
		}
%}

#define EV_BREAK EV_BREAK // A break was detected on input. 
#define EV_CTS EV_CTS // The CTS (clear-to-send) signal changed state. 
#define EV_DSR EV_DSR // The DSR (data-set-ready) signal changed state. 
#define EV_ERR EV_ERR // A line-status error occurred. Line-status errors are CE_FRAME, CE_OVERRUN, and CE_RXPARITY. 
#define EV_RING EV_RING // A ring indicator was detected. 
#define EV_RLSD EV_RLSD // The RLSD (receive-line-signal-detect) signal changed state. 
#define EV_RXCHAR EV_RXCHAR // A character was received and placed in the input buffer. 
#define EV_RXFLAG EV_RXFLAG // The event character was received and placed in the input buffer. The event character is specified in the device's DCB structure, which is applied to a serial port by using the SetCommState function. 
#define EV_TXEMPTY EV_TXEMPTY // The last character in the output buffer was sent.
#define CBR_110 CBR_110 
#define CBR_19200 CBR_19200
#define CBR_300 CBR_300 
#define CBR_38400 CBR_38400
#define CBR_600 CBR_600 
#define CBR_56000 CBR_56000
#define CBR_1200 CBR_1200
#define CBR_57600 CBR_57600
#define CBR_2400 CBR_2400
#define CBR_115200 CBR_115200
#define CBR_4800 CBR_4800
#define CBR_128000 CBR_128000
#define CBR_9600 CBR_9600
#define CBR_256000 CBR_256000
#define CBR_14400 CBR_14400 
#define DTR_CONTROL_DISABLE DTR_CONTROL_DISABLE // Disables the DTR line when the device is opened and leaves it disabled. 
#define DTR_CONTROL_ENABLE DTR_CONTROL_ENABLE // Enables the DTR line when the device is opened and leaves it on. 
#define DTR_CONTROL_HANDSHAKE DTR_CONTROL_HANDSHAKE // Enables DTR handshaking. If handshaking is enabled, it is an error for the application to adjust the line by using the EscapeCommFunction function. 
#define RTS_CONTROL_DISABLE RTS_CONTROL_DISABLE // Disables the RTS line when the device is opened and leaves it disabled. 
#define RTS_CONTROL_ENABLE RTS_CONTROL_ENABLE // Enables the RTS line when the device is opened and leaves it on. 
#define RTS_CONTROL_HANDSHAKE RTS_CONTROL_HANDSHAKE // Enables RTS handshaking. The driver raises the RTS line when the "type-ahead" (input) buffer is less than one-half full and lowers the RTS line when the buffer is more than three-quarters full. If handshaking is enabled, it is an error for the application to adjust the line by using the EscapeCommFunction function. 
#define RTS_CONTROL_TOGGLE RTS_CONTROL_TOGGLE // Specifies that the RTS line will be high if bytes are available for transmission. After all buffered bytes have been sent, the RTS line will be low. 
#define EVENPARITY EVENPARITY
#define MARKPARITY MARKPARITY
#define NOPARITY NOPARITY
#define ODDPARITY ODDPARITY
#define SPACEPARITY SPACEPARITY
#define ONESTOPBIT ONESTOPBIT
#define ONE5STOPBITS ONE5STOPBITS
#define TWOSTOPBITS TWOSTOPBITS 
#define CLRDTR CLRDTR // Clears the DTR (data-terminal-ready) signal. 
#define CLRRTS CLRRTS // Clears the RTS (request-to-send) signal. 
#define SETDTR SETDTR // Sends the DTR (data-terminal-ready) signal. 
#define SETRTS SETRTS // Sends the RTS (request-to-send) signal. 
#define SETXOFF SETXOFF // Causes transmission to act as if an XOFF character has been received. 
#define SETXON SETXON // Causes transmission to act as if an XON character has been received. 
#define SETBREAK SETBREAK // Suspends character transmission and places the transmission line in a break state until the ClearCommBreak function is called (or EscapeCommFunction is called with the CLRBREAK extended function code). The SETBREAK extended function code is identical to the SetCommBreak function. Note that this extended function does not flush data that has not been transmitted. 
#define CLRBREAK CLRBREAK // Restores character transmission and places the transmission line in a nonbreak state. The CLRBREAK extended function code is identical to the ClearCommBreak function. 
#define PURGE_TXABORT PURGE_TXABORT // Terminates all outstanding overlapped write operations and returns immediately, even if the write operations have not been completed. 
#define PURGE_RXABORT PURGE_RXABORT // Terminates all outstanding overlapped read operations and returns immediately, even if the read operations have not been completed. 
#define PURGE_TXCLEAR PURGE_TXCLEAR // Clears the output buffer (if the device driver has one). 
#define PURGE_RXCLEAR PURGE_RXCLEAR // Clears the input buffer (if the device driver has one). 

#define FILE_ENCRYPTABLE FILE_ENCRYPTABLE
#define FILE_IS_ENCRYPTED FILE_IS_ENCRYPTED
#define FILE_SYSTEM_ATTR FILE_SYSTEM_ATTR
#define FILE_ROOT_DIR FILE_ROOT_DIR
#define FILE_SYSTEM_DIR FILE_SYSTEM_DIR
#define FILE_UNKNOWN FILE_UNKNOWN
#define FILE_SYSTEM_NOT_SUPPORT FILE_SYSTEM_NOT_SUPPORT
#define FILE_USER_DISALLOWED FILE_USER_DISALLOWED
#define FILE_READ_ONLY FILE_READ_ONLY

// flags used with CopyFileEx
#define COPY_FILE_ALLOW_DECRYPTED_DESTINATION COPY_FILE_ALLOW_DECRYPTED_DESTINATION
#define COPY_FILE_FAIL_IF_EXISTS COPY_FILE_FAIL_IF_EXISTS
#define COPY_FILE_RESTARTABLE COPY_FILE_RESTARTABLE
#define COPY_FILE_OPEN_SOURCE_FOR_WRITE COPY_FILE_OPEN_SOURCE_FOR_WRITE

// return codes from CopyFileEx progress routine
#define PROGRESS_CONTINUE PROGRESS_CONTINUE
#define PROGRESS_CANCEL PROGRESS_CANCEL
#define PROGRESS_STOP PROGRESS_STOP
#define PROGRESS_QUIET PROGRESS_QUIET

// callback reasons from CopyFileEx
#define CALLBACK_CHUNK_FINISHED CALLBACK_CHUNK_FINISHED
#define CALLBACK_STREAM_SWITCH CALLBACK_STREAM_SWITCH

// flags used with ReplaceFile
#define REPLACEFILE_IGNORE_MERGE_ERRORS REPLACEFILE_IGNORE_MERGE_ERRORS
#define REPLACEFILE_WRITE_THROUGH REPLACEFILE_WRITE_THROUGH

// flags for OpenEncryptedFileRaw
#define CREATE_FOR_IMPORT CREATE_FOR_IMPORT
#define CREATE_FOR_DIR CREATE_FOR_DIR
#define OVERWRITE_HIDDEN OVERWRITE_HIDDEN
