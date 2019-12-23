﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ИдентификаторСессии;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Сертификат = Параметры.Сертификат;
	
	Если Не ЗначениеЗаполнено(Сертификат) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СпособДоставкиПаролей = "phone";
	
	ПараметрыПроцедуры = Новый Структура("ИдентификаторСертификата", СервисКриптографииСлужебный.Идентификатор(Сертификат));
	
	ДлительнаяОперация = СервисКриптографииСлужебный.ВыполнитьВФоне(
		"СервисКриптографииСлужебный.ПолучитьНастройкиПолученияВременныхПаролей", ПараметрыПроцедуры);
	
	ПарольОтправляется = Истина;
	Элементы.ФормаДругойСпособ.Видимость = Ложь;	
	Телефон = "...";
	
	НовыйЗаголовок 		= "";
	НовоеОписание 		= "";
	ПараметрыОперации 	= Неопределено;
	Параметры.Свойство("ПараметрыОперации", ПараметрыОперации);
	
	Если ТипЗнч(ПараметрыОперации) = Тип("Структура") Тогда
		ПараметрыОперации.Свойство("Операция", НовыйЗаголовок);
		ПараметрыОперации.Свойство("ЗаголовокДанных", НовоеОписание);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НовыйЗаголовок) Тогда
		Заголовок = НовыйЗаголовок;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НовоеОписание) Тогда
		Элементы.ДекорацияОписание.Заголовок = НовоеОписание;
	Иначе
		Элементы.ДекорацияОписание.Видимость = Ложь;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИдентификаторСессии = Неопределено;
	Оповещение = Новый ОписаниеОповещения("ПолучитьНастройкиПолученияВременныхПаролейПослеВыполнения", ЭтотОбъект);
	СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ДлительнаяОперация);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЦифраИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	СтандартнаяОбработка 	= Истина;
	
	Если СтрДлина(Текст) = 6 Тогда
		ИтоговыйНомер = СокрЛП(Текст);
		Цифры = "";
		Элементы.Цифры.ОбновитьТекстРедактирования();
		ПроверитьВведеныйКод(ИтоговыйНомер);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДругойСпособ(Команда)
	
	Если СпособДоставкиПаролей = "phone" Тогда
		СпособДоставкиПаролей = "email";
	Иначе
		СпособДоставкиПаролей = "phone";
	КонецЕсли;
	
	ИдентификаторСессии = "";
	ОтправитьПарольПовторно(Ложь);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Настройки(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Сертификат", Сертификат);
	ПараметрыФормы.Вставить("Состояние", "ИзменениеНастроекПолученияВременныхПаролей");
	
	ЗакрытьОткрытую(ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПовторитьОтправку(Команда)

	ОтправитьПарольПовторно();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОтправитьПарольПовторно(ПовторнаяОтправка = Истина)

	Оповещение = Новый ОписаниеОповещения("ПолучитьВременныйПарольПослеВыполнения", ЭтотОбъект);
		СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ПолучитьПарольНаСервере(ПовторнаяОтправка, ИдентификаторСессии));
		
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьНастройкиПолученияВременныхПаролейПослеВыполнения(Результат, ВходящийКонтекст) Экспорт
	
	Результат = СервисКриптографииСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(Результат);
	
	Если Результат.Выполнено Тогда
		Телефон          = Результат.РезультатВыполнения.Телефон;
		ЭлектроннаяПочта = Результат.РезультатВыполнения.ЭлектроннаяПочта;
		
		Оповещение = Новый ОписаниеОповещения("ПолучитьВременныйПарольПослеВыполнения", ЭтотОбъект);
		СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ПолучитьПарольНаСервере());
		УправлениеФормой(ЭтотОбъект);
		
	Иначе
		Оповещение = Новый ОписаниеОповещения("ПослеПоказаПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение(Оповещение, НСтр("ru = 'Сервис отправки SMS-сообщений временно недоступен. Повторите попытку позже.';
												|en = 'SMS service is temporarily unavailable. Try again later.'"));		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПарольНаСервере(Повторно = Ложь, ИдентификаторСессии = Неопределено)
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИдентификаторСертификата", СервисКриптографииСлужебный.Идентификатор(Сертификат));
	ПараметрыПроцедуры.Вставить("ПовторнаяОтправка", Повторно);
	ПараметрыПроцедуры.Вставить("Тип", СпособДоставкиПаролей);
	ПараметрыПроцедуры.Вставить("ИдентификаторСессии", ИдентификаторСессии);
	
	Возврат СервисКриптографииСлужебный.ВыполнитьВФоне(
		"СервисКриптографииСлужебный.ПолучитьВременныйПароль", ПараметрыПроцедуры);
	
КонецФункции

&НаКлиенте
Процедура ПолучитьВременныйПарольПослеВыполнения(Результат, ВходящийКонтекст) Экспорт
	
	Результат = СервисКриптографииСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(Результат);
	
	Если Результат.Выполнено Тогда
		Таймер = Результат.РезультатВыполнения.ЗадержкаПередПовторнойОтправкой;
		ПарольОтправлен = Истина;
		ПарольОтправляется = Ложь;
		Если Результат.РезультатВыполнения.Свойство("ИдентификаторСессии") Тогда 
			ИдентификаторСессии = Результат.РезультатВыполнения.ИдентификаторСессии;
		КонецЕсли;
		ЗапуститьОбратныйОтсчет();
		УправлениеФормой(ЭтотОбъект);
		ТекущийЭлемент = Элементы.Цифры;
		#Если МобильноеПриложениеКлиент Тогда
			НачатьРедактированиеЭлемента();
		#КонецЕсли	
	Иначе
		Оповещение = Новый ОписаниеОповещения("ПослеПоказаПредупреждения", ЭтотОбъект);
		ПоказатьПредупреждение(Оповещение, НСтр("ru = 'Сервис отправки SMS-сообщений временно недоступен. Повторите попытку позже.';
												|en = 'SMS service is temporarily unavailable. Try again later.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьОбратныйОтсчет()
	
	ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОбратногоОтсчета()
	
	Таймер 		= Таймер - 1;
	Отсрочка	= Макс(Отсрочка - 1, 0);

	Если Таймер >= 0 Тогда
		Если Отсрочка = 0 Тогда
			ОшибкаСостояние = СтрШаблон(НСтр("ru = 'Повторить через %1 сек.'"), Таймер);
		КонецЕсли;	
		ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОбратногоОтсчета", 1, Истина);		
	Иначе
		ОшибкаСостояние = "";
		ПарольОтправлен = Ложь;		
		Элементы.ФормаДругойСпособ.Видимость = ЗначениеЗаполнено(ЭлектроннаяПочта);
		Элементы.ФормаНастройки.Заголовок = НСтр("ru = 'Изменить адрес';
												|en = 'Change the address '");
		
		УправлениеФормой(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьОткрытую(ПараметрыФормы)
	
	Если Открыта() Тогда 
		Закрыть(ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПодтвердитьНаСервере(ТекущийКод, ИдентификаторСессии = Неопределено)
	
	ПарольПроверяется = Истина;

	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИдентификаторСертификата", СервисКриптографииСлужебный.Идентификатор(Сертификат));
	ПараметрыПроцедуры.Вставить("ВременныйПароль", ТекущийКод);
	ПараметрыПроцедуры.Вставить("ИдентификаторСессии", ИдентификаторСессии);
	
	Возврат СервисКриптографииСлужебный.ВыполнитьВФоне(
		"СервисКриптографииСлужебный.ПолучитьСеансовыйКлюч", ПараметрыПроцедуры);
	
КонецФункции

&НаКлиенте
Процедура ПослеПоказаПредупреждения(ВходящийКонтекст) Экспорт
	
	ЗакрытьОткрытую(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВведеныйКод(ТекущийКод)
	
	ОшибкаСостояние = "";
	Если ЗначениеЗаполнено(ТекущийКод) И СтрДлина(ТекущийКод) = 6 Тогда
		Оповещение = Новый ОписаниеОповещения("ПодтвердитьПарольПослеВыполнения", ЭтотОбъект);
		СервисКриптографииСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(Оповещение, ПодтвердитьНаСервере(ТекущийКод, ИдентификаторСессии));
		УправлениеФормой(ЭтотОбъект);
	ИначеЕсли ЗначениеЗаполнено(ТекущийКод) И СтрДлина(ТекущийКод) <> 6 Тогда
		ОшибкаСостояние = НСтр("ru = 'Пароль из 6 цифр'");
		Отсрочка		= 10;
	Иначе
		ОшибкаСостояние = НСтр("ru = 'Пароль не указан';
								|en = 'Password is not specified'");
		Отсрочка		= 10;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьПарольПослеВыполнения(Результат, ВходящийКонтекст) Экспорт

	Результат = СервисКриптографииСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(Результат);
	
	Если Результат.Выполнено Тогда
		СохранитьМаркерыБезопасности(Результат.РезультатВыполнения);
		ЗакрытьОткрытую(Новый Структура("Состояние", "ПарольПринят"));
	Иначе
		ПарольПроверяется = Ложь;
		УправлениеФормой(ЭтотОбъект);
		
		ТекстИсключения = ПодробноеПредставлениеОшибки(Результат.ИнформацияОбОшибке);
		Если СтрНайти(ТекстИсключения, "УказанНеверныйПароль") Тогда
			ОшибкаСостояние = НСтр("ru = 'Указан неверный пароль';
									|en = 'The password is incorrect'");
			Отсрочка		= 10;
			ТекущийЭлемент = Элементы.Цифры;
			#Если МобильноеПриложениеКлиент Тогда
				НачатьРедактированиеЭлемента();
			#КонецЕсли	
		ИначеЕсли СтрНайти(ТекстИсключения, "ПревышенЛимитПопытокВводаПароля") Тогда
			ЗакрытьОткрытую(Новый Структура("Состояние, ОписаниеОшибки", "ПарольНеПринят", НСтр("ru = 'Превышен лимит попыток ввода пароля';
																								|en = 'Exceeded number of attempts to enter password'"))); 
		ИначеЕсли СтрНайти(ТекстИсключения, "СрокДействияПароляИстек") Тогда
			ЗакрытьОткрытую(Новый Структура("Состояние, ОписаниеОшибки", "ПарольНеПринят", НСтр("ru = 'Срок действия пароля истек';
																								|en = 'Password expired'")));
		Иначе 
			ЗакрытьОткрытую(Новый Структура("Состояние, ОписаниеОшибки", "ПарольНеПринят", НСтр("ru = 'Выполнение операции временно невозможно';
																								|en = 'Operation temporarily cannot be executed'")));
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьМаркерыБезопасности(Знач МаркерыБезопасности)
	
	УстановитьПривилегированныйРежим(Истина);
	СервисКриптографииСлужебный.СохранитьМаркерыБезопасности(МаркерыБезопасности);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ПовторитьОтправку.Доступность = Не Форма.ПарольОтправлен И Не Форма.ПарольОтправляется;
	
	ТекстКоманды 	= НСтр("ru = 'Отправить пароль на %1';
							|en = 'Send password to %1'");
	ТемаОтправки	= "";
	Если Форма.СпособДоставкиПаролей = "phone" Тогда
		Если Форма.ПарольОтправляется Тогда
			ТемаОтправки = НСтр("ru = 'Выполняется отправка пароля в SMS-сообщении на номер';
								|en = 'Sending SMS message with password to the number'");
		Иначе
			ТемаОтправки = НСтр("ru = 'Пароль отправлен в SMS-сообщении на номер';
								|en = 'SMS message with password is sent to the number'");
		КонецЕсли;
		Элементы.ФормаНастройки.Заголовок = НСтр("ru = 'Изменить номер';
												|en = 'Change the number'");
		Элементы.ФормаДругойСпособ.Заголовок = СтрШаблон(ТекстКоманды, Форма.ЭлектроннаяПочта);
		ТемаОтправки = ТемаОтправки + Символы.ПС + Форма.Телефон;
	ИначеЕсли Форма.СпособДоставкиПаролей = "email" Тогда
		Если Форма.ПарольОтправляется Тогда
			ТемаОтправки = НСтр("ru = 'Выполняется отправка пароля в письме на адрес';
								|en = 'Sending email with password to the address'");
		Иначе
			ТемаОтправки = НСтр("ru = 'Пароль отправлен в письме на адрес';
								|en = 'Email with password is sent to the address'");
		КонецЕсли;	
		Элементы.ФормаНастройки.Заголовок = НСтр("ru = 'Изменить адрес';
												|en = 'Change the address '");
		Элементы.ФормаДругойСпособ.Заголовок = СтрШаблон(ТекстКоманды, Форма.Телефон);
		ТемаОтправки = ТемаОтправки + Символы.ПС + Форма.ЭлектроннаяПочта;
	КонецЕсли;
	
	Форма.ТекущееСостояние = ТемаОтправки;
	Элементы.ИндикаторДлительнойОперации.Видимость = Форма.ПарольОтправляется ИЛИ Форма.ПарольПроверяется;
	Элементы.ГруппаКод.Доступность = Не Форма.ПарольОтправляется И Не Форма.ПарольПроверяется;		
	Элементы.ГруппаКоманд.Доступность = Не Форма.ПарольОтправляется И Не Форма.ПарольПроверяется;
		
КонецПроцедуры

#КонецОбласти

