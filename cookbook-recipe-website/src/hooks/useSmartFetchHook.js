import { useState, useEffect, useMemo } from 'react';
import useDebounce from './useDebounce';

const useSmartFetchHook = (queryHook, options = {}, initialParams = {}) => {
  const [currentPage, setCurrentPage] = useState(1);
  const [searchTerm, setSearchTerm] = useState('');
  const [filterParams, setFilterParams] = useState(initialParams);
  
  // Debounce search term and search params
  const debouncedSearchTerm = useDebounce(searchTerm);
  const debouncedFilterParams = useDebounce(filterParams);

  const { resultsKey = 'results', ...queryOptions } = options;

  // Memoize the stringified debounced search params
  const stringifiedDebouncedParams = useMemo(
    () => JSON.stringify(debouncedFilterParams),
    [debouncedFilterParams]
  );

  // Combine all parameters for the query
  const queryParams = useMemo(() => ({
    page: currentPage,
    searchTerm: debouncedSearchTerm,
    ...debouncedFilterParams,
    ...queryOptions,
  }), [currentPage, debouncedSearchTerm, debouncedFilterParams, queryOptions]);

  const { data, isLoading, isError } = queryHook(queryParams);

  // Reset to first page when debounced search term or params change
  useEffect(() => {
    setCurrentPage(1);
  }, [debouncedSearchTerm, stringifiedDebouncedParams]);

  const rawResults = data?.data?.[resultsKey];
  const items = Array.isArray(rawResults) ? rawResults : [];
  const totalPages = data?.data?.meta?.totalPage || 1;

  return {
    searchTerm,
    setSearchTerm,
    currentPage,
    setCurrentPage,
    totalPages,
    items,
    isLoading,
    isError,
    filterParams,
    setFilterParams,
  };
};

export default useSmartFetchHook;