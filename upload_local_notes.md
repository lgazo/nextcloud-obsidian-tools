# upload local notes

The two scripts are responsible for checking if a local notes file exists remotely, and in case it does not, upload it.
NextCloud Android client is not capable to detect creation of a file in a directory, even when "Sync" or "Internal bi-directional sync" are turned on. Therefore you need to first upload it to the server. As there is no direct access to the NextCloud Android client API, the script is using WebDAV.

You need to create `.env` file in the directory where are the scripts with the following values:

```
NEXTCLOUD_USER=joe
NEXTCLOUD_PASSWORD=pass_or_APP_key_in_case_of_MFA
NEXTCLOUD_URL=https://your.nextcloud.domain/remote.php/dav/files
```

Then you can execute the script:

```termux
bash ./process_modified_files.sh ~/storage/shared/Android/media/com.nextcloud.client/nextcloud/user\@nextcloud.domain/Notes "2025-04-25"
```

