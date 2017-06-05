﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	Если Не РаботаВБезопасномРежимеСлужебный.ВозможноИспользованиеПрофилейБезопасности() Тогда
		ВызватьИсключение НСтр("ru = 'Использование профилей безопасности недоступно для данной конфигурации!'");
	КонецЕсли;
	
	Если Не РаботаВБезопасномРежимеСлужебный.ДоступнаНастройкаПрофилейБезопасности() Тогда
		ВызватьИсключение НСтр("ru = 'Настройка профилей безопасности недоступна!'");
	КонецЕсли;
	
	Если Не РежимРаботы.ЭтоАдминистраторСистемы Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа!'");
	КонецЕсли;
	
	// Настройки видимости при запуске.
	ПрочитатьРежимИспользованияПрофилейБезопасности();
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимИспользованияПрофилейБезопасностиПриИзменении(Элемент)
	
	Попытка
		
		НачатьПрименениеНастроекПрофилейБезопасности(ЭтотОбъект.УникальныйИдентификатор);
		
		ПредыдущийРежим = ТекущийРежимИспользованияПрофилейБезопасности();
		НовыйРежим = РежимИспользованияПрофилейБезопасности;
		
		Если (ПредыдущийРежим <> НовыйРежим) Тогда
			
			Если (ПредыдущийРежим = 2 Или НовыйРежим = 2) Тогда
				
				ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПослеЗакрытияПомощникаПримененияИзмененийВПрофиляхБезопасности", ЭтотОбъект, Истина);
				
				Если НовыйРежим = 2 Тогда
					
					НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент.НачатьВключениеИспользованияПрофилейБезопасности(ЭтотОбъект, ОповещениеОЗакрытии);
					
				Иначе
					
					НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент.НачатьОтключениеИспользованияПрофилейБезопасности(ЭтотОбъект, ОповещениеОЗакрытии);
					
				КонецЕсли;
				
			Иначе
				
				ЗавершитьПрименениеНастроекПрофилейБезопасности();
				УстановитьДоступность("РежимИспользованияПрофилейБезопасности");
				
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		
		ПрочитатьРежимИспользованияПрофилейБезопасности();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрофильБезопасностиИнформационнойБазыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ТребуемыеРазрешения(Команда)
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("СформироватьПриОткрытии", Истина);
	
	ОткрытьФорму(
		"Отчет.ИспользуемыеВнешниеРесурсы.ФормаОбъекта",
		ПараметрыОтчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьПрофилиБезопасности(Команда)
	
	Попытка
		
		НачатьПрименениеНастроекПрофилейБезопасности(ЭтотОбъект.УникальныйИдентификатор);
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПослеЗакрытияПомощникаПримененияИзмененийВПрофиляхБезопасности", ЭтотОбъект, Истина);
		НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент.НачатьВосстановлениеПрофилейБезопасности(ЭтотОбъект, ОповещениеОЗакрытии);
		
	Исключение
		
		ПрочитатьРежимИспользованияПрофилейБезопасности();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВнешнююОбработку(Команда)
	
	ОткрытьФорму("Обработка.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.Форма.ОткрытиеВнешнейОбработкиИлиОтчетаСВыборомБезопасногоРежима");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура ПослеЗакрытияПомощникаПримененияИзмененийВПрофиляхБезопасности(Результат, ТребуетсяПерезапускКлиентскогоПриложения) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ЗавершитьПрименениеНастроекПрофилейБезопасности();
	КонецЕсли;
	
	ПрочитатьРежимИспользованияПрофилейБезопасности();
	
	Если Результат = КодВозвратаДиалога.ОК И ТребуетсяПерезапускКлиентскогоПриложения Тогда
		ПрекратитьРаботуСистемы(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьРежимИспользованияПрофилейБезопасности()
	
	РежимИспользованияПрофилейБезопасности = ТекущийРежимИспользованияПрофилейБезопасности();
	УстановитьДоступность("РежимИспользованияПрофилейБезопасности");
	
КонецПроцедуры

&НаСервере
Функция ТекущийРежимИспользованияПрофилейБезопасности()
	
	Если РаботаВБезопасномРежимеСлужебный.ВозможноИспользованиеПрофилейБезопасности() И ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") Тогда
		
		Если Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Получить() Тогда
			
			Результат = 2; // Из текущей ИБ
			
		Иначе
			
			Результат = 1; // Через консоль кластера
			
		КонецЕсли;
		
	Иначе
		
		Результат = 0; // Не используются
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура НачатьПрименениеНастроекПрофилейБезопасности(Знач УникальныйИдентификатор)
	
	Если Не РаботаВБезопасномРежимеСлужебный.ВозможноИспользованиеПрофилейБезопасности() Тогда
		ВызватьИсключение НСтр("ru = 'Включение автоматического запроса разрешений недоступно!'");
	КонецЕсли;
	
	УстановитьМонопольныйРежим(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьПрименениеНастроекПрофилейБезопасности()
	
	Если РежимИспользованияПрофилейБезопасности = 0 Тогда
		
		Константы.ИспользуютсяПрофилиБезопасности.Установить(Ложь);
		Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Установить(Ложь);
		Константы.ПрофильБезопасностиИнформационнойБазы.Установить("");
		
	ИначеЕсли РежимИспользованияПрофилейБезопасности = 1 Тогда
		
		Константы.ИспользуютсяПрофилиБезопасности.Установить(Истина);
		Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Установить(Ложь);
		
	ИначеЕсли РежимИспользованияПрофилейБезопасности = 2 Тогда
		
		Константы.ИспользуютсяПрофилиБезопасности.Установить(Истина);
		Константы.АвтоматическиНастраиватьРазрешенияВПрофиляхБезопасности.Установить(Истина);
		
	КонецЕсли;
	
	Если МонопольныйРежим() Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	#Если НЕ ВебКлиент Тогда
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РежимРаботы.ЭтоАдминистраторСистемы Тогда
		
		Если РеквизитПутьКДанным = "РежимИспользованияПрофилейБезопасности" ИЛИ РеквизитПутьКДанным = "" Тогда
			
			Элементы.ГруппаПрофилиБезопасностиКолонкаПравая.Доступность = РежимИспользованияПрофилейБезопасности > 0;
			
			Элементы.ПрофильБезопасностиИнформационнойБазы.ТолькоПросмотр = (РежимИспользованияПрофилейБезопасности = 2);
			Элементы.ГруппаВосстановлениеПрофилейБезопасности.Доступность = (РежимИспользованияПрофилейБезопасности = 2);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
