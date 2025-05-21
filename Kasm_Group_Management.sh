#!/bin/bash

# Print usage message
usage() {
    echo "Usage: $0 [-d value | --domain value] [-k value | --key value] [-s value | --secret value] "
    exit 1
}

# Parse flags and their arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--domain)
            if [[ -n "$2" && "$2" != -* ]]; then
                DOMAIN="$2"
                shift
            else
                echo "Error: -d|--domain requires a value."
                usage
            fi
            ;;
        -k|--key)
            if [[ -n "$2" && "$2" != -* ]]; then
                KEY="$2"
                shift
            else
                echo "Error: -k|--key requires a value."
                usage
            fi
            ;;
        -s|--secret)
            if [[ -n "$2" && "$2" != -* ]]; then
                SECRET="$2"
                shift
            else
                echo "Error: -s|--secret requires a value."
                usage
            fi
            ;;
        -f|--force)
            FORCE=1
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
    shift
done

# Validate required arguments
if [[ -z "$DOMAIN" || -z "$KEY" || -z "$SECRET" ]]; then
    echo "Error: All three flags (-d, -k, -s) are required."
    usage
fi

Group_Config_Lookup () {
    case "$1" in
        "Administrators") 
            echo "Administrators Configs"
            description="Default Kasm administrators group."
            priority="1"
            permissions='["global_admin"]'
            settings='[
                {   "name": "allow_kasm_pause", 
                    "value": "True",
                    "value_type": "bool"
                },
                {   "name": "allow_kasm_stop", 
                    "value": "True",
                    "value_type": "bool"
                },
                {   "name": "allow_totp_2fa", 
                    "value": "True",
                    "value_type": "bool"
                },
                {   "name": "disabled_image_message", 
                    "value": "This image is currently disabled.",
                    "value_type": "string"
                },
                {   "name": "require_2fa", 
                    "value": "True",
                    "value_type": "bool"
                },
                {   "name": "show_disabled_images", 
                    "value": "True",
                    "value_type": "bool"
                }
            ]'
            ;;
        "All Users")
            echo "All Users Configs"
            description="Default Kasm users group."
            priority="2"
            permissions='["user"]'
            settings='[
                {
                    "name":"allow_kasm_pause",
                    "value": "False",
                    "value_type": "bool"
                },
                {
                    "name":"allow_kasm_stop",
                    "value": "False",
                    "value_type": "bool"
                },
                {
                    "name":"keepalive_expiration_action",
                    "value": "delete",
                    "value_type": "string"
                },
                {
                    "name":"usage_limit",
                    "value": "{}",
                    "value_type": "usage_limit"
                }
                ]'
            ;;
        "Site Administrators")
            echo "Site Administrators"
            description="Kasm SaaS administrators group."
            priority="3"
            permissions='[
                "user",
                "users_view",
                "users_modify",
                "users_create",
                "users_delete",
                "users_auth_session",
                "groups_view",
                "groups_modify",
                "groups_create",
                "groups_delete",
                "groups_view_ifmember",
                "groups_modify_ifmember",
                "agents_view",
                "staging_view",
                "casting_view",
                "casting_modify",
                "casting_create",
                "casting_delete",
                "sessions_view",
                "sessions_modify",
                "sessions_delete",
                "session_recordings_view",
                "images_view",
                "images_modify",
                "images_create",
                "images_delete",
                "images_modify_resources",
                "devapi_view",
                "webfilters_view",
                "webfilters_modify",
                "webfilters_create",
                "webfilters_delete",
                "brandings_view",
                "brandings_modify",
                "brandings_create",
                "brandings_delete",
                "settings_view",
                "settings_modify_auth",
                "settings_modify_storage",
                "auth_view",
                "auth_modify",
                "auth_create",
                "auth_delete",
                "licenses_view",
                "system_view",
                "system_export_schema",
                "reports_view",
                "zones_view",
                "connection_proxy_view",
                "physical_tokens_view",
                "physical_tokens_modify",
                "physical_tokens_create",
                "physical_tokens_delete",
                "servers_view",
                "autoscale_schedule_view",
                "registries_view",
                "registries_modify",
                "registries_create",
                "registries_delete",
                "storage_providers_view",
                "storage_providers_modify",
                "storage_providers_create",
                "storage_providers_delete",
                "egress_gateways_view",
                "egress_gateways_modify",
                "egress_gateways_create",
                "egress_gateways_delete",
                "egress_credentials_view",
                "egress_credentials_modify",
                "egress_credentials_create",
                "egress_credentials_delete",
                "ad_user_management_view",
                "ad_user_management_modify",
                "ad_user_management_create",
                "ad_user_management_delete"
                ]'
            ;;
        "Workspace Administrators" )
            echo "Workspace Administrators"
            description="Kasm Workspace administrators group."
            priority="4"
            permissions='[
                "user",
                "users_view",
                "groups_view",
                "agents_view",
                "staging_view",
                "casting_view",
                "casting_modify",
                "casting_create",
                "casting_delete",
                "sessions_view",
                "sessions_modify",
                "sessions_delete",
                "images_view",
                "images_modify",
                "images_create",
                "images_delete",
                "images_modify_resources",
                "webfilters_view",
                "system_view",
                "reports_view",
                "zones_view",
                "servers_view",
                "server_pools_view",
                "registries_view",
                "registries_modify",
                "registries_create",
                "registries_delete",
                "storage_providers_view"
            ]'

            ;;
        "All Site (users)")
            echo "All Site (users)"
            description="Kasm All site users group."
            priority="1000"
            permissions='["user"]'
            settings='[
                {
                    "name":"allow_2fa_self_enrollment",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_kasm_audio",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_kasm_clipboard_down",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_kasm_clipboard_seamless",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_kasm_clipboard_up",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_kasm_delete",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_kasm_downloads",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_kasm_gamepad",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_kasm_microphone",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_kasm_printing",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_kasm_sharing",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_kasm_uploads",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_kasm_webcam",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_persistent_profile",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_totp_2fa",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_user_storage_mapping",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"allow_webauthn_2fa",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"auto_add_local_users",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"control_panel.advanced_settings.show_game_mode",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"control_panel.advanced_settings.show_ime_input_mode",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"control_panel.advanced_settings.show_keyboard_controls",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"control_panel.advanced_settings.show_pointer_lock",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"control_panel.advanced_settings.show_prefer_local_cursor",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"control_panel.show_delete_session",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"control_panel.show_fullscreen",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"control_panel.show_logout",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"control_panel.show_return_to_workspaces",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"control_panel.show_streaming_quality",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"idle_disconnect",
                    "value": "20",
                    "value_type": "float"
                },
                {
                    "name":"kasm_audio_default_on",
                    "value": "True",
                    "value_type": "bool"
                },
                {
                    "name":"keepalive_expiration",
                    "value": "3600",
                    "value_type": "int"
                },
                {
                    "name":"keepalive_expiration_action",
                    "value": "delete",
                    "value_type": "string"
                },
                {
                    "name":"max_kasms_per_user",
                    "value": "5",
                    "value_type": "int"
                },
                {
                    "name":"max_user_storage_mappings",
                    "value": "2",
                    "value_type": "int"
                },
                {
                    "name":"read_only_user_storage_mapping",
                    "value": "False",
                    "value_type": "bool"
                }
                ]'

            ;;
        *)
            echo "Unknown option: $1"
            ;;
    esac

}

Group_Config_Override () {
    local description=$1
    local priority=$2
    local group_id=$3
    local group_name=$4
    curl "https://${DOMAIN}/api/admin/update_group" \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        --data-raw "{\"target_group\":{\"description\":\"$description\",\"is_system\":true,\"name\":\"$group_name\",    \"priority\":\"$priority\",\"form_metadata\":[],\"group_id\":\"$group_id\",\"group_metadata\":{}},\"api_key\":\"${KEY}\",     \"api_key_secret\":\"${SECRET}\"}" \
        --insecure
}

Settings_Config () {  
    ####                                                                      ####      
    ##        PLEASE PASS IN THE SETTINGS STRING FROM Group_Config_Lookup()     ##          
    ####                                                                      ####   

    if [[ "$1" == 'null' ]]; then
        echo "Settings null... returning to main"
        return
    fi

    settings_references="$(curl -k "https://${DOMAIN}/api/admin/get_settings_group" -H 'Accept: application/json' -H 'Content-Type: application/json' --data-raw "{\"target_group\":{},\"api_key\":\"${KEY}\",\"api_key_secret\":\"${SECRET}\"}" | jq -r .settings)"
    local existing_settings="$(curl -k "https://${DOMAIN}/api/admin/get_settings_group" -H 'Accept: application/json' -H 'Content-Type: application/json' --data-raw "{\"target_group\":{\"group_id\":\"${2}\"},\"api_key\":\"${KEY}\",\"api_key_secret\":\"${SECRET}\"}" | jq -r .settings)"


    ## Set each setting
    for (( setting_index=0; setting_index<$( echo $1 | jq -r '. | length'); setting_index++ )); do
        local setting_name=$(echo $1 | jq -r .[$setting_index].name)
        local reference_index=$(echo "$settings_references" | jq "to_entries | map(select(.value.name == \"$setting_name\")) | .[0].key // -1")
        local existing_index=$(echo "$existing_settings" | jq "to_entries | map(select(.value.name == \"$setting_name\")) | .[0].key // -1")
        local setting_id="$(echo $settings_references | jq -r .[$reference_index].group_setting_id)"

        ## If setting is already set, update it. else add it.
        if [[ "$existing_index" != '-1' ]];then
            if [[ "$FORCE" == 1 ]]; then
                local setting_value="$(echo $existing_settings | jq -r .[$setting_index].value)"
            else
                local setting_value="$(echo $1 | jq -r .[$setting_index].value)"
            fi
            echo "data: \"{\"target_group\":{\"group_id\":\"${2}\"},\"target_setting\":{\"group_setting_id\":\"${setting_id}\",\"value\":\"${setting_value}\"},}\""
            curl "https://${DOMAIN}/api/admin/update_settings_group" \
                -H 'Accept: application/json' \
                -H 'Content-Type: application/json' \
                --data-raw "{\"target_group\":{\"group_id\":\"${2}\"},\"target_setting\":{\"group_setting_id\":\"${setting_id}\",\"value\":\"${setting_value}\"},}" \
                --insecure
        else
            local setting_value="$(echo $1 | jq -r .[$setting_index].value)"
            local response=$(curl -k "https://${DOMAIN}/api/admin/add_settings_group" \
            -H 'Accept: application/json' \
            -H 'Content-Type: application/json' \
            --data-raw "{\"target_group\":{\"group_id\":\"${2}\"},\"target_setting\":{\"group_setting_id\":\"${setting_id}\",   \"value\":\"${setting_value}\"},\"api_key\":\"${KEY}\",\"api_key_secret\":\"${SECRET}\"}")
            fi 
    done
}

Permissions_Config () {
    ####                                                                      ####      
    ##        PLEASE PASS IN THE PERMISSIONS STRING FROM Group_Config_Lookup()     ##          
    ####                                                                      ####  
    
    if [[ "$1" == 'null' ]]; then
        echo "Permissions null... returning to main"
        return
    fi

    permissions_references="$(curl -k "https://${DOMAIN}/api/admin/get_permissions" -H 'Accept: application/json' -H 'Content-Type: application/json' --data-raw "{\"api_key\":\"${KEY}\",\"api_key_secret\":\"${SECRET}\"}" | jq -r .permissions)"
    local existing_permissions="$(curl -k "https://${DOMAIN}/api/admin/get_permissions_group" -H 'Accept: application/json' -H 'Content-Type: application/json' --data-raw "{\"target_group\":{\"group_id\":\"${2}\"},\"api_key\":\"${KEY}\",\"api_key_secret\":\"${SECRET}\"}" | jq -r .permissions)"

    


    # ## Set each Permission
    for (( permission_index=0; permission_index<$( echo $1 | jq -r '. | length'); permission_index++ )); do
        local permission_name=$(echo $1 | jq -r .[$permission_index])
        local reference_index=$(echo "$permissions_references" | jq "to_entries | map(select((.value.name | ascii_upcase) == ( \"JWT_AUTHORIZATION.$permission_name\" | ascii_upcase ))) | .[0].key // -1")
        local existing_index=$(echo "$existing_permissions" | jq "to_entries | map(select((.value.permission_name | ascii_upcase) == ( \"JWT_AUTHORIZATION.$permission_name\" | ascii_upcase ))) | .[0].key // -1")
        local permission_id="$(echo $permissions_references | jq  -r .[$reference_index].permission_id)"


        ##### TODO:: ADD LOGIC TO REMOVE ALL PERMISSIONS BEFORE APPLY FOR --FORCE
        

        ## implement permission to group
        local response=$(curl -k "https://${DOMAIN}/api/admin/add_permissions_group" \
            -H 'Accept: application/json' \
            -H 'Content-Type: application/json' \
            --data-raw "{
            \"target_group\":{\"group_id\":\"${2}\"},
            \"target_permissions\":[${permission_id}],
            \"api_key\":\"${KEY}\",
            \"api_key_secret\":\"${SECRET}\"
            }"
            )
    done

}


## Create SaaS Groups 
GROUPS_TO_CREATE=("Administrators" "All Users" "Site Administrators" "Workspace Administrators" "All Site (users)")
EXISTING_GROUPS_REFERENCE=$(curl -k "https://${DOMAIN}/api/admin/get_groups" -H 'Accept: application/json' -H 'Content-Type: application/json' --data-raw "{\"api_key\":\"${KEY}\",\"api_key_secret\":\"${SECRET}\"}" | jq -r .groups)

for i in "${!GROUPS_TO_CREATE[@]}"; do
    GROUP_NAME="${GROUPS_TO_CREATE[$i]}"
    Group_Config_Lookup "${GROUP_NAME}"
    echo "Configuring Group \"${GROUP_NAME}\""

    ## Check if group exists and create it if not
    GROUP_EXISTS=$(echo $EXISTING_GROUPS_REFERENCE | jq "to_entries | map(select(.value.name == \"${GROUP_NAME}\")) | .[0].key // -1")
    if [[ "$GROUP_EXISTS" == '-1' ]]; then
        echo "Group \"${GROUP_NAME}\" not found... Creating..."
        GROUP_ID="$(curl -k "https://${DOMAIN}/api/admin/create_group" -H 'Accept: application/json' -H 'Content-Type: application/json' --data-raw "{\"target_group\":{\"name\":\"${GROUP_NAME}\",\"priority\":\"$priority\"},\"api_key\":\"${KEY}\",\"api_key_secret\":\"${SECRET}\"}" | jq .group.group_id )"
    else
        echo "Group \"${GROUP_NAME}\" found... Skipping Group Creation..."
        GROUP_ID="$(echo $EXISTING_GROUPS_REFERENCE | jq -r .[$GROUP_EXISTS].group_id)"
    fi

    ## Configure the group
    if [[ "$FORCE" == 1 ]]; then
    Group_Config_Override "${description}" "${priority}" "${GROUP_ID}" "${GROUP_NAME}"
    fi
    Settings_Config "${settings}" "${GROUP_ID}"
    Permissions_Config "${permissions}" "${GROUP_ID}"
    unset $GROUP_ID
done
unset $i
