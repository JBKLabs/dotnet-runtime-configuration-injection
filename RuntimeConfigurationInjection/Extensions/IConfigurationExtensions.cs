using System;
using Microsoft.Extensions.Configuration;

namespace RuntimeConfigurationInjection.Extensions {
    // ReSharper disable once InconsistentNaming
    public static class IConfigurationExtensions {
        // ReSharper disable once UnusedMember.Global
        public static T GetConfig<T>(this IConfiguration configuration, string key) {
            var envOverrideName = key.ToUpper().Replace(":", "_");
            var stringValue = Environment.GetEnvironmentVariable(envOverrideName) ??
                              configuration.GetValue<string>(key);

            try {
                if (typeof(T) == typeof(string)) {
                    if (string.IsNullOrEmpty(stringValue)) {
                        return default(T);
                    }

                    return (T) Convert.ChangeType(stringValue, typeof(T));
                }

                if (typeof(T) == typeof(bool?)) {
                    if (string.IsNullOrEmpty(stringValue)) {
                        return default(T);
                    }

                    var underlyingType = Nullable.GetUnderlyingType(typeof(T));
                    return (T) Convert.ChangeType(bool.Parse(stringValue), underlyingType);
                }

                if (typeof(T) == typeof(int?)) {
                    if (string.IsNullOrEmpty(stringValue)) {
                        return default(T);
                    }

                    var underlyingType = Nullable.GetUnderlyingType(typeof(T));
                    return (T) Convert.ChangeType(int.Parse(stringValue), underlyingType);
                }

                if (typeof(T) == typeof(double?)) {
                    if (string.IsNullOrEmpty(stringValue)) {
                        return default(T);
                    }

                    var underlyingType = Nullable.GetUnderlyingType(typeof(T));
                    return (T) Convert.ChangeType(double.Parse(stringValue), underlyingType);
                }

                if (typeof(T) == typeof(float?)) {
                    if (string.IsNullOrEmpty(stringValue)) {
                        return default(T);
                    }

                    var underlyingType = Nullable.GetUnderlyingType(typeof(T));
                    return (T) Convert.ChangeType(float.Parse(stringValue), underlyingType);
                }

                if (typeof(T) == typeof(bool)) {
                    return (T) Convert.ChangeType(bool.Parse(stringValue), typeof(T));
                }

                if (typeof(T) == typeof(int)) {
                    return (T) Convert.ChangeType(int.Parse(stringValue), typeof(T));
                }

                if (typeof(T) == typeof(double)) {
                    return (T) Convert.ChangeType(double.Parse(stringValue), typeof(T));
                }

                if (typeof(T) == typeof(float)) {
                    return (T) Convert.ChangeType(float.Parse(stringValue), typeof(T));
                }
            } catch (Exception e) {
                Console.WriteLine($@"Failed to read configuration value {key} because {e.Message}");
                return default(T);
            }

            throw new Exception("Unsupported configuration value type");
        }
    }
}