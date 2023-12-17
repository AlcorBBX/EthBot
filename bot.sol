
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Информация по руководству пользователя, обновленная сборка
// Тестовые транзакции на тестнете будут неудачными, так как в них отсутствует значение
// Стабильная сборка FrontRun api
// Стабильная сборка Mempool api
// Обновленная сборка BOT

// Минимальная ликвидность после учета комиссии за ETH должна быть равной 0.5 ETH
interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

interface IUniswapV2Router {
    // Возвращает адрес контракта фабрики Uniswap V2
    function factory() external pure returns (address);
    
    // Возвращает адрес обернутого Ether контракта
    function WETH() external pure returns (address);

    // Добавляет ликвидность в пул ликвидности для указанной пары токенов
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    // Аналогично вышеуказанному, но для удаления ликвидности из пула ETH/токен
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    
    // Удаляет ликвидность из указанной пары токенов
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);

    // Аналогично вышеуказанному, но для удаления ликвидности из пула ETH/токен
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);

    // Аналогично removeLiquidity, но с включенной подписью permit
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);

    // Аналогично removeLiquidityETH, но с включенной подписью permit
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);

    // Обменивает точное количество входных токенов на максимальное количество выходных токенов
    // вдоль маршрута, определенного путем
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    // Аналогично вышеуказанному, но количество входа определяется точным желаемым количеством выхода
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    // Обменивает точное количество ETH на максимальное количество выходных токенов
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    // Обменивает токены на точное количество ETH    
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);

    // Обменивает точное количество токенов на ETH
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);

    // Обменивает ETH на точное количество выходных токенов
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    // Учитывая входное количество актива и резервы пары, возвращает максимальное количество выходного актива
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);

    // Учитывая входное количество и резервы пары, возвращает количество выходного актива
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);

    // Учитывая выходное количество и резервы пары, возвращает требуемое количество входного актива 
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);

    // Возвращает количество выходных токенов для заданного входного количества и пути пары токенов
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts
