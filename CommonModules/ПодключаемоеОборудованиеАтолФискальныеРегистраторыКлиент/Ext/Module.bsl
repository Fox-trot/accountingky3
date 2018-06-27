﻿
#Область ПрограммныйИнтерфейс

// Функция возвращает возможность работы модуля в асинхронном режиме.
// Стандартные команды модуля:
// - ПодключитьУстройство
// - ОтключитьУстройство
// - ВыполнитьКоманду
// Команды модуля для работы асинхронном режиме (должны быть определены):
// - НачатьПодключениеУстройства
// - НачатьОтключениеУстройства
// - НачатьВыполнениеКоманды.
//
Функция ПоддержкаАсинхронногоРежима() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Функция осуществляет подключение устройства.
//
Функция ПодключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;
	ПараметрыПодключения.Вставить("ИДУстройства", "");

	ВыходныеПараметры = Новый Массив();
	
	// Проверка параметров устройства.
	Порт                       = Неопределено;
	Скорость                   = Неопределено;
	Таймаут                    = Неопределено;
	ПарольПользователя         = Неопределено;
	ПарольУстройства           = Неопределено;
	ПечататьНалогиВЧеке        = Неопределено;
	НомерСекции                = Неопределено;
	КодСимволаЧастичногоОтреза = Неопределено;

	Параметры.Свойство("Порт"                      , Порт);
	Параметры.Свойство("Скорость"                  , Скорость);
	Параметры.Свойство("Таймаут"                   , Таймаут);
	Параметры.Свойство("ПарольПользователя"        , ПарольПользователя);
	Параметры.Свойство("ПарольУстройства"          , ПарольУстройства);
	Параметры.Свойство("ПечататьНалогиВЧеке"       , ПечататьНалогиВЧеке);
	Параметры.Свойство("НомерСекции"               , НомерСекции);
	Параметры.Свойство("КодСимволаЧастичногоОтреза", КодСимволаЧастичногоОтреза);

	Если Порт                       = Неопределено
	 Или Скорость                   = Неопределено
	 Или Таймаут                    = Неопределено
	 Или ПарольПользователя         = Неопределено
	 Или ПарольУстройства           = Неопределено
	 Или ПечататьНалогиВЧеке        = Неопределено
	 Или НомерСекции                = Неопределено
	 Или КодСимволаЧастичногоОтреза = Неопределено Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Не настроены параметры устройства.
		|Для корректной работы устройства необходимо задать параметры его работы.
		|Сделать это можно при помощи формы ""Настройка параметров"" модели
		|подключаемого оборудования в форме ""Подключение и настройка оборудования"".'"));

		Результат = Ложь;
	КонецЕсли;
	// Конец: Проверка параметров устройства.

	Если Результат Тогда
		Если Параметры.Модель = Неопределено Тогда
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

			Результат = Ложь;
		КонецЕсли;

		МассивЗначений = Новый Массив;
		МассивЗначений.Добавить(Параметры.Порт);
		МассивЗначений.Добавить(Параметры.Скорость);
		МассивЗначений.Добавить(Параметры.ПарольПользователя);
		МассивЗначений.Добавить(Параметры.ПарольУстройства);
		МассивЗначений.Добавить(Параметры.Модель);
		МассивЗначений.Добавить(Параметры.ПечататьНалогиВЧеке);

		Если ОбъектДрайвера.Подключить(МассивЗначений, ПараметрыПодключения.ИДУстройства) Тогда
			ВыходныеПараметры.Добавить(""); // Источник событий
			ВыходныеПараметры.Добавить(Неопределено); // Список событий
		Иначе
			ВыходныеПараметры.Добавить(999);
			ВыходныеПараметры.Добавить("");
			ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

			Результат = Ложь;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отключение устройства.
//
Функция ОтключитьУстройство(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Ложь;

	// Обязательные выходные
	ВыходныеПараметры = Новый Массив();

	Если НЕ ОбъектДрайвера.Отключить(ПараметрыПодключения.ИДУстройства) Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
	Иначе
		Результат = Истина;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция получает, обрабатывает и перенаправляет на исполнение команду к драйверу.
//
Функция ВыполнитьКоманду(Команда, ВходныеПараметры = Неопределено, ВыходныеПараметры = Неопределено,
                         ОбъектДрайвера, Параметры, ПараметрыПодключения) Экспорт

	Результат = Истина;
	
	ВыходныеПараметры = Новый Массив();
	
	// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩИЕ ДЛЯ РАБОТЫ С ФИСКАЛЬНЫМИ РЕГИСТРАТОРАМИ
	
	// Открыть смену
	Если Команда = "OpenShift" ИЛИ Команда = "ОткрытьСмену" Тогда
		Результат = ОткрытьСмену(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Закрыть кассовую смену
	ИначеЕсли Команда = "CloseShift" ИЛИ Команда = "ЗакрытьСмену" Тогда
		Результат = НапечататьОтчетСГашением(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Печать отчета без гашения
	ИначеЕсли Команда = "PrintXReport" ИЛИ Команда = "НапечататьОтчетБезГашения" Тогда
		Результат = НапечататьОтчетБезГашения(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Печать отчета с гашением
	ИначеЕсли Команда = "PrintZReport" ИЛИ Команда = "НапечататьОтчетСГашением" Тогда
		Результат = НапечататьОтчетСГашением(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Отчет о текущем состоянии расчетов
	ИначеЕсли Команда = "ReportCurrentStatusOfSettlements" ИЛИ Команда = "ОтчетОТекущемСостоянииРасчетов" Тогда
		Результат = НапечататьОтчетБезГашения(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Печать по шаблону
	ИначеЕсли Команда = "PrintReceiptByTemplate" ИЛИ Команда = "ПечатьЧекаПоШаблону" Тогда
		Результат = ПечатьЧекаПоШаблону(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВходныеПараметры, ВыходныеПараметры);
		
	// Фискализация чека.
	ИначеЕсли Команда = "CheckFiscalization" ИЛИ Команда = "ФискализацияЧека" Тогда
		Результат = ПечатьЧекаПоШаблону(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВходныеПараметры, ВыходныеПараметры);
		
	//  Аннулирование чека
	ИначеЕсли Команда = "AnnulCheck" ИЛИ Команда = "АннулироватьЧек" Тогда
		ТипЧека       = ВходныеПараметры[0];
		ФискальныйЧек = ВходныеПараметры[1];
		Результат = АннулироватьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТипЧека, ФискальныйЧек, ВыходныеПараметры);
		
	// Печать слип чека
	ИначеЕсли Команда = "PrintText" ИЛИ Команда = "ПечатьТекста"  Тогда
		СтрокаТекста   = ВходныеПараметры[0];
		Результат = ПечатьТекста(ОбъектДрайвера, Параметры, ПараметрыПодключения,
		                         СтрокаТекста, ВыходныеПараметры);
	// Открыть открытый чек
	ИначеЕсли Команда = "OpenCheck" ИЛИ Команда = "ОткрытьЧек"  Тогда
		ЧекВозврата   = ВходныеПараметры[0];
		ФискальныйЧек = ВходныеПараметры[1];
		Результат = ОткрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ЧекВозврата, ФискальныйЧек, ВыходныеПараметры);
		
	// Отменить открытый чек
	ИначеЕсли Команда = "CancelCheck" ИЛИ Команда = "ОтменитьЧек"  Тогда
		Результат = ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Печать чека внесения/выемки.
	ИначеЕсли Команда = "Encash" ИЛИ Команда = "Инкассация" Тогда
		Результат = Инкассация(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВходныеПараметры, ВыходныеПараметры);

	ИначеЕсли Команда = "PrintBarCode" ИЛИ Команда = "ПечатьШтрихкода" Тогда
		ТипШтрихКодаЗнач = ВходныеПараметры[0];
		ШтрихКод     = ВходныеПараметры[1];
		Результат = ПечатьШтрихкода(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТипШтрихКодаЗнач, ШтрихКод, ВыходныеПараметры);
	
	// Открытие денежного ящика
	ИначеЕсли Команда = "OpenCashDrawer" ИЛИ Команда = "ОткрытьДенежныйЯщик" Тогда
		Результат = ОткрытьДенежныйЯщик(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Получение ширины строки в символах.
	ИначеЕсли Команда = "GetLineLength" ИЛИ Команда = "ПолучитьШиринуСтроки" Тогда
		Результат = ПолучитьШиринуСтроки(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
		// Получение версии драйвера
	ИначеЕсли Команда = "ПолучитьВерсиюДрайвера" Тогда
		Результат = ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);

	// Тестирование устройства
	ИначеЕсли Команда = "ТестУстройства" ИЛИ Команда = "CheckHealth" Тогда
		Результат = ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
		
	// Указанная команда не поддерживается данным драйвером.
	Иначе
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""%Команда%"" не поддерживается данным драйвером.'"));
		ВыходныеПараметры[1] = СтрЗаменить(ВыходныеПараметры[1], "%Команда%", Команда);
		Результат = Ложь;

	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция осуществляет открытие смены.
//
Функция ОткрытьСмену(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	// Заполнение выходных параметров.
	ВыходныеПараметры.Добавить(0);
	ВыходныеПараметры.Добавить(0);
	ВыходныеПараметры.Добавить(0);
	ВыходныеПараметры.Добавить(МенеджерОборудованияКлиентПереопределяемый.ДатаСеанса());
	ВыходныеПараметры.Добавить(Неопределено);
	ВыходныеПараметры.Добавить(Неопределено);
	ВыходныеПараметры.Добавить(Неопределено);
	ВыходныеПараметры.Добавить(Неопределено);
	
	Возврат Результат;

КонецФункции

// Осуществляет печать чека по шаблону.
//
Функция ПечатьЧекаПоШаблону(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВходныеПараметры, ВыходныеПараметры) Экспорт
	       
	Возврат МенеджерОборудованияКлиент.ПечатьЧекаПоШаблону(ПодключаемоеОборудованиеАтолФискальныеРегистраторыКлиент,
		ОбъектДрайвера, Параметры, ПараметрыПодключения, ВходныеПараметры, ВыходныеПараметры);
	
КонецФункции

// Осуществляет аннулирование чека.
//
Функция АннулироватьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТипЧека, ФискальныйЧек, ВыходныеПараметры) 
	
	Результат = ОткрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТипЧека, ФискальныйЧек, ВыходныеПараметры);
	Если Результат Тогда
		Результат = ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	КонецЕсли;
		
	Возврат Результат;           
	
КонецФункции

// Осуществляет печать слип чека.
//
Функция ПечатьТекста(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры) Экспорт

	Результат  = Истина;

	// Открываем чек
	Результат = ОткрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, Ложь, Ложь, ВыходныеПараметры);

	// Печатаем строки чека
	Если Результат Тогда
		Для НомерСтроки = 1 По СтрЧислоСтрок(СтрокаТекста) Цикл
			ВыделеннаяСтрока = СтрПолучитьСтроку(СтрокаТекста, НомерСтроки);
			Если (Найти(ВыделеннаяСтрока, Символ(Параметры.КодСимволаЧастичногоОтреза)) > 0)
				Или (Найти(ВыделеннаяСтрока, "[отрезка]") > 0)
				Или (Найти(ВыделеннаяСтрока, "[cut]") > 0) Тогда
				ТаблицаОплат = Новый Массив();
				Результат = ЗакрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТаблицаОплат, ВыходныеПараметры);
				Результат = ОткрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, Ложь, Ложь, ВыходныеПараметры);
			Иначе
				Если НЕ НапечататьНефискальнуюСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения,
				                                     ВыделеннаяСтрока, ВыходныеПараметры) Тогда
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Закрываем чек
	Если Результат Тогда
		ТаблицаОплат = Новый Массив();
		Результат = ЗакрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТаблицаОплат, ВыходныеПараметры);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет открытие нового чека.
//
Функция ОткрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ЧекВозврата, ФискальныйЧек, ВыходныеПараметры) Экспорт

	Результат  = Истина;
	НомерСмены = 0;
	НомерЧека  = 0;

	// Открываем чек
	Результат = ОбъектДрайвера.ОткрытьЧек(ПараметрыПодключения.ИДУстройства, ФискальныйЧек, ЧекВозврата,
	                                      Истина, НомерЧека, НомерСмены);
	Если НЕ Результат Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
	Иначе
		// Заполнение выходных параметров.
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(НомерСмены);
		ВыходныеПараметры.Добавить(НомерЧека);
		ВыходныеПараметры.Добавить(0); // Номер документа
		ВыходныеПараметры.Добавить(МенеджерОборудованияКлиентПереопределяемый.ДатаСеанса());
		ВыходныеПараметры.Добавить("");
		ВыходныеПараметры.Добавить("");
		ВыходныеПараметры.Добавить("");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Функция осуществляет печать фискальной строки.
//
Функция НапечататьФискальнуюСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения,
                                   Наименование, Количество, Цена, Сумма,
                                   НомерСекции, СтавкаНДС, ВыходныеПараметры) Экспорт

	Результат = Истина;

	Результат = ОбъектДрайвера.НапечататьФискСтроку(ПараметрыПодключения.ИДУстройства, Наименование, Количество, Цена,
	                                                Сумма, НомерСекции, СтавкаНДС);
	
	Если НЕ Результат Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

		ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет печать нефискальной строки.
//
Функция НапечататьНефискальнуюСтроку(ОбъектДрайвера, Параметры, ПараметрыПодключения, СтрокаТекста, ВыходныеПараметры) Экспорт

	Результат = Истина;

	Результат = ОбъектДрайвера.НапечататьНефискСтроку(ПараметрыПодключения.ИДУстройства, СтрокаТекста);
	Если НЕ Результат Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

		ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет закрытие ранее открытого чека.
//
Функция ЗакрытьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТаблицаОплат, ВыходныеПараметры) Экспорт

	Результат = Истина;

	СуммаНаличнойОплаты    = 0;
	СуммаБезналичнойОплаты = 0;

	Для ИндексОплаты = 0 По ТаблицаОплат.Количество() - 1 Цикл
		Если ТаблицаОплат[ИндексОплаты][0].Значение = 0 Тогда
			СуммаНаличнойОплаты = СуммаНаличнойОплаты + ТаблицаОплат[ИндексОплаты][1].Значение;
		Иначе
			СуммаБезналичнойОплаты = СуммаБезналичнойОплаты + ТаблицаОплат[ИндексОплаты][1].Значение;
		КонецЕсли;
	КонецЦикла;

	Результат = ОбъектДрайвера.ЗакрытьЧек(ПараметрыПодключения.ИДУстройства,
	                                      СуммаНаличнойОплаты, СуммаБезналичнойОплаты);
	Если НЕ Результат Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

		ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет отмену ранее открытого чека.
//
Функция ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт

	Результат = Истина;

	ОбъектДрайвера.ОтменитьЧек(ПараметрыПодключения.ИДУстройства);

	Возврат Результат;

КонецФункции

// Функция осуществляет внесение или выемку суммы на ФР.
//
Функция Инкассация(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВходныеПараметры, ВыходныеПараметры)
	
	ТипИнкассации  = ?(ВходныеПараметры.Свойство("ТипИнкассации"), ВходныеПараметры.ТипИнкассации, 0);  
	Сумма          = ?(ВходныеПараметры.Свойство("Сумма"), ВходныеПараметры.Сумма, 0);  
	
	Результат = ОбъектДрайвера.НапечататьЧекВнесенияВыемки(ПараметрыПодключения.ИДУстройства, ?(ТипИнкассации = 1, Сумма, -Сумма));
	Если НЕ Результат Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

		ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	Иначе
		// Заполнение выходных параметров.
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(МенеджерОборудованияКлиентПереопределяемый.ДатаСеанса());
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет снятие отчета без гашения.
//
Функция НапечататьОтчетБезГашения(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	Результат = ОбъектДрайвера.НапечататьОтчетБезГашения(ПараметрыПодключения.ИДУстройства);
	Если НЕ Результат Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

		ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	Иначе
		// Заполнение выходных параметров.
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(МенеджерОборудованияКлиентПереопределяемый.ДатаСеанса());
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет снятие отчета с гашением.
//
Функция НапечататьОтчетСГашением(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	Результат = ОбъектДрайвера.НапечататьОтчетСГашением(ПараметрыПодключения.ИДУстройства);
	Если НЕ Результат Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

		ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	Иначе
		// Заполнение выходных параметров.
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(0);
		ВыходныеПараметры.Добавить(МенеджерОборудованияКлиентПереопределяемый.ДатаСеанса());
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет печать штрихкода.
//
Функция ПечатьШтрихкода(ОбъектДрайвера, Параметры, ПараметрыПодключения, ТипШтрихКодаЗнач, ШтрихКод, ВыходныеПараметры) Экспорт
	
	Результат = Истина;
	
	СтрокаТекста = НСтр("ru='ШТРИХКОД:'") + ШтрихКод; 
	Результат = ОбъектДрайвера.НапечататьНефискСтроку(ПараметрыПодключения.ИДУстройства, СтрокаТекста);
	Если НЕ Результат Тогда
		ВыходныеПараметры.Очистить();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);

		ОтменитьЧек(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция осуществляет открытие денежного ящика.
//
Функция ОткрытьДенежныйЯщик(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	Попытка
		Результат = ОбъектДрайвера.ОткрытьДенежныйЯщик(ПараметрыПодключения.ИДУстройства);
	Исключение
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(НСтр("ru='Команда ""Открыть денежный ящик"" не поддерживается данным драйвером.'"));
		Возврат Результат;
	КонецПопытки;
		
	Если НЕ Результат Тогда
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить("");
		ОбъектДрайвера.ПолучитьОшибку(ВыходныеПараметры[1]);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция получает ширину строки в символах.
//  
Функция ПолучитьШиринуСтроки(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры) Экспорт
	
	Результат = Истина;
	ШиринаСтроки = Неопределено;
	ВыходныеПараметры.Очистить();  
	ВыходныеПараметры.Добавить(ШиринаСтроки);
	Возврат Результат;
	
КонецФункции

// Функция осуществляет Тест Устройства
//
Функция ТестУстройства(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)
	
	Результат = Истина;
	РезультатТеста = "";
	
	МассивЗначений = Новый Массив;
	МассивЗначений.Добавить(Параметры.Порт);
	МассивЗначений.Добавить(Параметры.Скорость);
	МассивЗначений.Добавить(Параметры.ПарольПользователя);
	МассивЗначений.Добавить(Параметры.ПарольУстройства);
	МассивЗначений.Добавить(Параметры.Модель);
	МассивЗначений.Добавить(Параметры.ПечататьНалогиВЧеке);

	Результат = ОбъектДрайвера.ТестУстройства(МассивЗначений, РезультатТеста);

	ВыходныеПараметры.Добавить(?(Результат, 0, 999));
	ВыходныеПараметры.Добавить(РезультатТеста);

	Возврат Результат;

КонецФункции

// Функция возвращает версию установленного драйвера.
//
Функция ПолучитьВерсиюДрайвера(ОбъектДрайвера, Параметры, ПараметрыПодключения, ВыходныеПараметры)

	Результат = Истина;

	ВыходныеПараметры.Добавить(НСтр("ru='Установлен'"));
	ВыходныеПараметры.Добавить(НСтр("ru='Не определена'"));

	Попытка
		ВыходныеПараметры[1] = ОбъектДрайвера.ПолучитьНомерВерсии();
	Исключение
		Результат = Ложь;
	КонецПопытки;

	Возврат Результат;

КонецФункции

#КонецОбласти
