﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИнициализироватьРеквизитыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьПорядковыйНомерПерехода(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ТекстПредупреждения = НСтр("ru = 'Не выполнять удаление настройки синхронизации данных?'");
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
		ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, "ЗакрытьФормуБезусловно");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		Оповестить("ЗакрытаФормаУдаленияНастройкиСинхронизации");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	ЗакрытьФормуБезусловно = Истина;
	Закрыть(УзелОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УдалениеНастройкиСинхронизации

&НаКлиенте
Процедура ПриНачалеУдаленияНастройкиСинхронизации()
	
	ПродолжитьОжидание = Истина;
	
	ПриНачалеУдаленияНастройкиСинхронизацииНаСервере(ПродолжитьОжидание);
	
	Если ПродолжитьОжидание Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(
			ПараметрыОбработчикаОжиданияУдаленияНастройкиСинхронизации);
			
		ПодключитьОбработчикОжидания("ПриОжиданииУдаленияНастройкиСинхронизации",
			ПараметрыОбработчикаОжиданияУдаленияНастройкиСинхронизации.ТекущийИнтервал, Истина);
	Иначе
		ПриЗавершенииУдаленияНастройкиСинхронизации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОжиданииУдаленияНастройкиСинхронизации()
	
	ПродолжитьОжидание = Ложь;
	ПриОжиданииУдаленияНастройкиСинхронизацииНаСервере(ПараметрыОбработчикаУдаленияНастройкиСинхронизации, ПродолжитьОжидание);
	
	Если ПродолжитьОжидание Тогда
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжиданияУдаленияНастройкиСинхронизации);
		
		ПодключитьОбработчикОжидания("ПриОжиданииУдаленияНастройкиСинхронизации",
			ПараметрыОбработчикаОжиданияУдаленияНастройкиСинхронизации.ТекущийИнтервал, Истина);
	Иначе
		ПараметрыОбработчикаОжиданияУдаленияНастройкиСинхронизации = Неопределено;
		ПриЗавершенииУдаленияНастройкиСинхронизации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииУдаленияНастройкиСинхронизации()
	
	СообщениеОбОшибке = "";
	
	НастройкаУдалена = Истина;
	НастройкаУдаленаВКорреспонденте = Истина;
	
	ПриЗавершенииУдаленияНастройкиСинхронизацииНаСервере(НастройкаУдалена,
		НастройкаУдаленаВКорреспонденте, СообщениеОбОшибке);
	
	Если НастройкаУдалена Тогда
		ИзменитьПорядковыйНомерПерехода(+1);
		
		Если УдалитьНастройкуВКорреспонденте
			И НастройкаУдаленаВКорреспонденте Тогда
			Элементы.ДекорацияСинхронизацияУдаленаНадпись.Заголовок = НСтр("ru = 'Настройки синхронизации данных в этой программе
			|и программе-корреспонденте успешно удалены.'");
		КонецЕсли;
		
	Иначе
		ИзменитьПорядковыйНомерПерехода(-1);
		
		Если Не ПустаяСтрока(СообщениеОбОшибке) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не удалось удалить настройку синхронизации данных.'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриНачалеУдаленияНастройкиСинхронизацииНаСервере(ПродолжитьОжидание)
	
	НастройкиУдаления = Новый Структура;
	НастройкиУдаления.Вставить("УзелОбмена", УзелОбмена);
	НастройкиУдаления.Вставить("УдалитьНастройкуВКорреспонденте", УдалитьНастройкуВКорреспонденте);
	
	Обработки.ПомощникСозданияОбменаДанными.ПриНачалеУдаленияНастройкиСинхронизации(НастройкиУдаления,
		ПараметрыОбработчикаУдаленияНастройкиСинхронизации, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриОжиданииУдаленияНастройкиСинхронизацииНаСервере(ПараметрыОбработчика, ПродолжитьОжидание)
	
	ПродолжитьОжидание = Ложь;
	Обработки.ПомощникСозданияОбменаДанными.ПриОжиданииУдаленияНастройкиСинхронизации(ПараметрыОбработчика, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗавершенииУдаленияНастройкиСинхронизацииНаСервере(НастройкаУдалена, НастройкаУдаленаВКорреспонденте, СообщениеОбОшибке)
	
	СтатусЗавершения = Неопределено;
	Обработки.ПомощникСозданияОбменаДанными.ПриЗавершенииУдаленияНастройкиСинхронизации(
		ПараметрыОбработчикаУдаленияНастройкиСинхронизации, СтатусЗавершения);
		
	Если СтатусЗавершения.Отказ Тогда
		НастройкаУдалена = Ложь;
		
		СообщениеОбОшибке = СтатусЗавершения.СообщениеОбОшибке;
		Возврат;
	Иначе
		НастройкаУдалена = СтатусЗавершения.Результат.НастройкаУдалена;
		НастройкаУдаленаВКорреспонденте = СтатусЗавершения.Результат.НастройкаУдаленаВКорреспонденте;
		
		СообщениеОбОшибке = СтатусЗавершения.СообщениеОбОшибке;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнициализацияФормыПриСоздании

&НаСервере
Процедура ИнициализироватьРеквизитыФормы()
	
	УзелОбмена = Параметры.УзелОбмена;
	
	МодельСервиса = ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
	
	Если Не МодельСервиса Тогда
		ВидТранспорта = РегистрыСведений.НастройкиТранспортаОбменаДанными.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелОбмена);
		ПодключениеOnline = (ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.COM
			Или ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	КонецЕсли;
	
	УдалитьНастройкуВКорреспонденте = ПодключениеOnline;
		
	ЗаполнитьТаблицуПереходов();
	
КонецПроцедуры

#КонецОбласти

#Область СценарииРаботыПомощника

&НаСервере
Функция ДобавитьСтрокуТаблицыПереходов(ИмяОсновнойСтраницы, ИмяСтраницыНавигации, ИмяСтраницыДекорации = "")
	
	СтрокаПереходов = ТаблицаПереходов.Добавить();
	СтрокаПереходов.ПорядковыйНомерПерехода = ТаблицаПереходов.Количество();
	СтрокаПереходов.ИмяОсновнойСтраницы = ИмяОсновнойСтраницы;
	СтрокаПереходов.ИмяСтраницыНавигации = ИмяСтраницыНавигации;
	СтрокаПереходов.ИмяСтраницыДекорации = ИмяСтраницыДекорации;
	
	Возврат СтрокаПереходов;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуПереходов()
	
	ТаблицаПереходов.Очистить();
	
	НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаНачало", "СтраницаНавигацияНачало");
	НовыйПереход.ИмяОбработчикаПриОткрытии = "СтраницаНачало_ПриОткрытии";
	
	НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаОжидание", "СтраницаНавигацияОжидание");
	НовыйПереход.ИмяОбработчикаПриОткрытии = "СтраницаОжидание_ПриОткрытии";
	НовыйПереход.ДлительнаяОперация = Истина;
	НовыйПереход.ИмяОбработчикаДлительнойОперации = "СтраницаОжидание_ДлительнаяОперация";
	
	НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаОкончание", "СтраницаНавигацияОкончание");
	НовыйПереход.ИмяОбработчикаПриОткрытии = "СтраницаОкончание_ПриОткрытии";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПереходов

&НаКлиенте
Функция Подключаемый_СтраницаНачало_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Элементы.ГруппаНачалоДополнительно.Видимость = ПодключениеOnline;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаОжидание_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПослеУдаленияРазрешений", ЭтотОбъект, УзелОбмена);
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		Запросы = ОбменДаннымиВызовСервера.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов(УзелОбмена);
		МодульРаботаВБезопасномРежимеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВБезопасномРежимеКлиент");
		МодульРаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(Запросы, Неопределено, ОповещениеОЗакрытии);
	Иначе
		ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, КодВозвратаДиалога.ОК);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаОжидание_ДлительнаяОперация(Отказ, ПерейтиДалее)
	
	ПерейтиДалее = Ложь;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаОкончание_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Оповестить("Запись_УзелПланаОбмена");
	ЗакрытьФормы("ФормаУзла");
	
КонецФункции

#КонецОбласти

#Область ДополнительныеОбработчикиПереходов

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 1 Тогда
		
		ПорядковыйНомерПерехода = 1;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода.
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц.
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	Элементы.ПанельНавигации.ТекущаяСтраница.Доступность = Не (ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация);
	
	// Устанавливаем текущую кнопку по умолчанию.
	КнопкаДалее = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаДалее");
	
	Если КнопкаДалее <> Неопределено Тогда
		
		КнопкаДалее.КнопкаПоУмолчанию = Истина;
		
	Иначе
		
		КнопкаГотово = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаГотово");
		
		Если КнопкаГотово <> Неопределено Тогда
			
			КнопкаГотово.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов.
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			СтрокаПерехода = СтрокиПерехода[0];
		
			// Обработчик ПриПереходеДалее.
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
					
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			СтрокаПерехода = СтрокиПерехода[0];
		
			// Обработчик ПриПереходеНазад.
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
					
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			Если ЭтоПереходДалее Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				
				Возврат;
				
			Иначе
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// Обработчик ОбработкаДлительнойОперации.
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПерейтиДалее Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКнопкуФормыПоИмениКоманды(ЭлементФормы, ИмяКоманды)
	
	Для Каждого Элемент Из ЭлементФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			
			Если ЭлементФормыПоИмениКоманды <> Неопределено Тогда
				
				Возврат ЭлементФормыПоИмениКоманды;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И СтрНайти(Элемент.ИмяКоманды, ИмяКоманды) > 0 Тогда
			
			Возврат Элемент;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

&НаКлиенте
Процедура ПослеУдаленияРазрешений(Результат, УзелИнформационнойБазы) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ПриНачалеУдаленияНастройкиСинхронизации();
	Иначе
		ИзменитьПорядковыйНомерПерехода(-1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормы(Знач ИмяФормы)
	
	ОкнаПриложения = ПолучитьОкна();
	
	Если ОкнаПриложения = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Для Каждого ОкноПриложения Из ОкнаПриложения Цикл
		Если ОкноПриложения.Основное Тогда
			Продолжить;
		КонецЕсли;
			
		Форма = ОкноПриложения.ПолучитьСодержимое();
		
		Если ТипЗнч(Форма) = Тип("УправляемаяФорма")
			И Не Форма.Модифицированность
			И СтрНайти(Форма.ИмяФормы, ИмяФормы) <> 0 Тогда
			
			Форма.Закрыть();
			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти